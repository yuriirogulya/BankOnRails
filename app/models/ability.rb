class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role?('admin')
      can :manage, User
    elsif user.role?('user')
      can :show, User, id: user.id
      can :update, User, id: user.id
    end
  end
end
