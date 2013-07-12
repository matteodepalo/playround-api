class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Round, user_id: user.id
    can :manage, User, id: user.id

    can [:start, :declare_winner], Round do |round|
      can? :manage, round
    end
  end
end