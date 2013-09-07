class CheckTimerExpirationJob < Struct.new(:timer_id)
  def perform
    timer = Timer.find_by_id(timer_id)
    timer.send(:check_expiration) if timer
  end
end
