class AccountsController < ApplicationController
  before_action :find_account, except: %i[index]
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def transaction
    TransactionService.new(params).perform
    redirect_to accounts_url
  end

  private

  def find_account
    @user = User.find(params[:user_id])
    @account = @user.accounts.find(params[:account_id])
  end
end
