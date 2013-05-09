class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Round, :user_id => user.id
  end
end