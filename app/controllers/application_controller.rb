class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  before_filter :start_unstarted_games

  # XXX: Move this to DelayJob or some other asynchronous mechanism.
  # For now, it's not worth setting up true asynchronous events and we just
  # check for games that need to be started on every request.
  def start_unstarted_games
    Game.scheduled.due.each do |game|
      game.start!
    end
  end
end
