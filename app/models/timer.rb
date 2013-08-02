class Timer < ActiveRecord::Base
  attr_accessible :started_at, :paused_at, :seconds_paused, :duration

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
      transition any - :created => :created
    end

    after_transition :created => :running, :do => :set_started_at
    after_transition :running => :paused, :do => :set_paused_at
    after_transition :paused => :running, :do => :clear_paused_at
    after_transition any => :created, :do => :reset_timer

    state :running do
      def elapsed_time
        diff_in_seconds(DateTime.now, started_at) - seconds_paused
      end
    end

    state :paused do
      def elapsed_time
        diff_in_seconds(paused_at, started_at) - seconds_paused
      end
    end

    state :running, :paused do
      def time_remaining
        duration - elapsed_time
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

  def diff_in_seconds(a, b)
    (a.to_datetime - b.to_datetime) * 1.day
  end

  def to_hms(seconds)
    seconds = seconds.to_i
    hours = seconds / 3600
    minutes = (seconds / 60) % 60
    seconds = seconds % 60

    if hours > 0
      format("%02dh%02dm%02ds", hours, minutes, seconds)
    elsif minutes > 0
      format("%02dm%02ds", minutes, seconds)
    else
      format("%02ds", seconds)
    end
  end
end
