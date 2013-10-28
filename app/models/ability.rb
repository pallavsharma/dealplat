class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    can :manage, :all

    can :manage, Marker, :user_id => user.id

  end

end
