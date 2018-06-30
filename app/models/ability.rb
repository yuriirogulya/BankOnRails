class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :all_accounts, to: :check_all_accounts

    user ||= User.new
    if user.role?('admin')
      can :manage, [User, Account]
    elsif user.role?('user')
      can :manage, User, id: user.id
      cannot :index, [User, Account]
      cannot :check_all_accounts, Account
    end
  end
end
