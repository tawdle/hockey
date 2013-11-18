class Timer < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true

  attr_accessible :started_at, :paused_at, :seconds_paused, :duration, :owner, :offset

  state_machine :initial => :created do
    event :start do
      transition [:created, :paused] => :running
    end

    event :pause do
      transition :running => :paused
    end

    event :stop do
      transition [:running, :paused] => :stopped
    end

    event :reset do
      transition any => :created
    end

    event :expire do
      transition [:running, :paused] => :expired
    end

    after_transition :expired => any, :do => :reset_timer
    after_transition :created => :running, :do => :set_started_at
    after_transition :running => :paused, :do => :set_paused_at
    after_transition :paused => :running, :do => :clear_paused_at
    after_transition any => :created, :do => :reset_timer
    after_transition any => :running, :do => :queue_expiration_check
    after_transition any => :expired, :do => :notify_owner_of_expiration

    state :created do
      def elapsed_time
        0
      end
    end
    state :running do
      def elapsed_time
        clamp_by_duration(diff_in_seconds(DateTime.now, started_at) - seconds_paused)
      end
    end

    state :paused do
      def elapsed_time
        clamp_by_duration(diff_in_seconds(paused_at, started_at) - seconds_paused)
      end
    end

    state :expired do
      def elapsed_time
        duration
      end
    end

    state :created, :running, :paused, :expired do
      def time_remaining
        [duration - elapsed_time, 0.0].max
      end
      def elapsed_time_hms
        to_hms(elapsed_time)
      end
      def time_remaining_hms
        to_hms(time_remaining)
      end
    end

    state :created do
      def time_remaining
        duration
      end
    end
  end

  def elapsed_time=(val)
    if val.is_a?(String)
      val = val.split(":").map(&:to_f)
      seconds = val.pop
      seconds += val.pop * 60 if val.any?
      seconds += val.pop * 3600 if val.any?
    else
      seconds = val.to_f
    end
    self.seconds_paused = diff_in_seconds(paused? ? paused_at : DateTime.now, started_at) - seconds
  end

  private

  def set_started_at
    update_attributes(:started_at => DateTime.now)
  end

  def set_paused_at
    update_attributes(:paused_at => DateTime.now)
  end

  def clear_paused_at
    pause_duration = diff_in_seconds(DateTime.now, paused_at)
    update_attributes(:paused_at => nil, :seconds_paused => seconds_paused + pause_duration)
  end

  def reset_timer
    update_attributes(:paused_at => nil, :seconds_paused => 0.0, :started_at => nil)
  end

  def queue_expiration_check
    Delayed::Job.enqueue(CheckTimerExpirationJob.new(id), :run_at => estimated_expiration) if duration
  end

  def estimated_expiration
    DateTime.now + time_remaining.seconds
  end

  def check_expiration
    expire! if running? && duration && time_remaining <= 0
  end

  def notify_owner_of_expiration
    owner.timer_expired(id) if owner
  end

  def diff_in_seconds(a, b)
    (a.to_datetime - b.to_datetime) * 1.day
  end

  def clamp_by_duration(val)
    duration ? [val, duration].min : val
  end

  def to_hms(seconds)
    seconds = seconds.to_i
    hours = seconds / 3600
    minutes = (seconds / 60) % 60
    seconds = seconds % 60

    hours > 0 ?
      format("%d:%02d:%02d", hours, minutes, seconds) :
      format("%02d:%02d", minutes, seconds)
  end
end
