class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, ActivityFeedItem do |item|
      item.creator == user
    end

    can [:create, :destroy], Following do |following|
      user == following.user
    end

    can :read, Game

    can :manage, Game do |game|
      user.manager_of?(game.home_team.try(:league)) || user.manager_of?(game.visiting_team.try(:league))
    end

    can [:mark, :start, :stop], Game do |game|
      user.marker_of_game?(game)
    end

    can :edit, GameOfficial do |game_official|
      user.marker_of_game?(game_official.try(:game))
    end

    can :manage, GameStaffMember do |gsm|
      user.marker_of_game?(gsm.try(:game))
    end

    can :manage, Goal do |goal|
      user.marker_of_game?(goal.try(:game))
    end

    can :manage, Penalty do |penalty|
      user.marker_of_game?(penalty.try(:game))
    end

    can [:edit, :update], User do |user_object|
      user_object == user
    end

    can [:impersonate], User do |user_object|
      user.admin?
    end

    can :read, League

    can [:create, :update, :destroy], League do |league|
      user.admin?
    end

    can :read, Official

    can :manage, Official do |official|
      official.leagues.any? {|league| user.manager_of?(league) }
    end

    can :manage, Location do
      user.admin?
    end

    can :manage, StaffMember do |staff_member|
      user.manager_of?(staff_member.team) || user.marker_of?(staff_member.team.league)
    end

    can :read, Team
    can :read, Player

    can :create, Team do |team|
      league = team.league || League.managed_by(user).first
      league && user.manager_of?(league)
    end

    can [:edit, :update], Team do |team|
      user.manager_of?(team) || user.manager_of?(team.league)
    end

    can :destroy, Team do |team|
      user.admin?
    end

    can :manage, Player do |player|
      user.manager_of?(player.team) || user.marker_of?(player.league)
    end

    can :create, Invitation do |invitation|
      user.manager_of?(invitation.target) ||
        (invitation.target.is_a?(Team) && user.manager_of?(invitation.target.league)) ||
        (invitation.target.is_a?(League) && user.admin?)
    end

    can [:accept, :decline], Invitation do |invitation|
      user.persisted?
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
