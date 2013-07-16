class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:create, :destroy], Following do |following|
      user == following.user
    end

    can [:edit, :update], User do |user_object|
      user_object == user
    end

    can :read, League

    can [:create, :update, :destroy], League do |league|
      user.admin?
    end

    can :read, Team
    can :read, TeamMembership

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

    can [:create, :destroy], TeamMembership do |team_membership|
      user.manager_of?(team_membership.team)
    end

    can :create, Invitation do |invitation|
      user.manager_of?(invitation.target) ||
        (invitation.target.is_a?(Team) && user.manager_of?(invitation.target.league))
    end

    can [:accept, :decline], Invitation do
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
