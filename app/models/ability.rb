class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Feed::UserPost do |item|
      item.creator == user
    end

    can [:create, :destroy], Following do |following|
      user == following.user
    end

    can :read, Game

    can [:create, :update, :destroy], Game do |game|
      user.manager_of?(game.league)
    end

    can [:mark, :activate, :complete, :pause, :start, :finish, :sync, :update_clock, :set_mvp], Game do |game|
      user.marker_of?(game.league) && !game.completed?
    end

    can :manage, GameGoalie do |game_goalie|
      user.marker_of?(game_goalie.game.league)
    end

    can :edit, GameOfficial do |game_official|
      user.marker_of?(game_official.game.league)
    end

    can :manage, GameStaffMember do |gsm|
      user.marker_of?(gsm.game.league)
    end

    can :manage, Goal do |goal|
      user.marker_of?(goal.game.league)
    end

    can :create, Invitation do |invitation|
      target = invitation.target
      case target
      when League, Tournament, Location
        user.admin? || user.manager_of?(target)
      when Player
        case invitation.predicate
        when :claim
          user.manager_of?(target.team)
        when :follow
          user.persisted?
        end
      when Team
        user.manager_of?(target.league)
      end
    end

    can [:accept, :decline], Invitation do |invitation|
      user.persisted?
    end

    can :manage, Kiosk do
      user.admin?
    end

    can :read, League

    can [:create, :update, :destroy], League do |league|
      user.admin?
    end

    can :read, Location

    can :manage, Location do |location|
      user.admin? || user.manager_of?(location)
    end

    can :read, Official

    can :manage, Official do |official|
      user.manager_of?(official.league)
    end

    can :manage, Penalty do |penalty|
      user.marker_of?(penalty.game.league)
    end

    can :manage, StaffMember do |staff_member|
      user.manager_of?(staff_member.team) || user.marker_of?(staff_member.team.league)
    end

    can :read, Player

    can :claim, Player do |player|
      user.persisted? && player.user.nil?
    end

    can :manage, Player do |player|
      user.manager_of?(player.team) || user.marker_of?(player.league)
    end

    can [:read, :approve, :deny], PlayerClaim do |player_claim|
      user.manager_of?(player_claim.player.team)
    end

    can :create, PlayerClaim do |player_claim|
      user.persisted?
    end

    can :read, Team

    can :create, Team do |team|
      league = team.league || League.managed_by(user).first
      league && user.manager_of?(league)
    end

    can [:edit, :update], Team do |team|
      user.manager_of?(team) || user.manager_of?(team.league)
    end

    can :destroy, Team do |team|
      user.admin? || user.manager_of?(team.league)
    end

    can :read, Tournament

    can :update, Tournament do |tournament|
      user.manager_of?(tournament)
    end

    can :manage, Tournament do |tournament|
      user.admin?
    end

    can [:edit, :update], User do |user_object|
      user_object == user
    end

    can [:impersonate], User do |user_object|
      user.admin?
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
