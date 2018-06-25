class AccountsController < ApplicationController
  before_action :find_account, only: %i[transaction]
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def transaction
    amount = params[:account][:amount].to_i
    operation = params[:commit]
    account = params[:account_id]
    if TransactionService.new(operation, account, amount).perform
      TransactionService.new(operation, account, amount).write_logs
      redirect_to accounts_url, notice: 'Your balance updated'
    else
      redirect_to accounts_url, alert: 'Your balance could not be updated. Not enough funds'
    end
  end

  private

  def find_account
    @user = User.find(params[:user_id])
    @account = @user.accounts.find(params[:account_id])
  end
end
