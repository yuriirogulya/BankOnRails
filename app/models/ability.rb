class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role?('admin')
      can :manage, User
    elsif user.role?('user')
      can :manage, User, id: user.id
      cannot :index, User
    end
  end
end
