class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Round, user_id: user.id
    can :manage, User, id: user.id
    can :start, Round, user_id: user.id
    can :declare_winner, Round, user_id: user.id
  end
end