class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.role?('admin')
      can :manage, [User, Account]
    elsif user.role?('user')
      can :manage, User, id: user.id
      cannot :index, User
      can :manage, Account
    end
  end
end