class AccountsController < ApplicationController
  before_action :find_account, only: %i[show edit update destroy withdraw]
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def show; end

  def edit; end

  def withdraw
    new_amount = @account.amount - params[:account][:amount].to_i
    @account.update(amount: new_amount)
  end

  private

  def find_account
    @user = User.find(params[:user_id])
    @account = @user.accounts.find(params[:account_id])
  end
end
