class AccountsController < ApplicationController
  before_action :find_account, except: %i[index]
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def transaction
    if params[:commit] == 'Withdraw'
      new_amount = @account.amount - amount_params.to_i
      @account.update(amount: new_amount)
    elsif params[:commit] == 'Deposit'
      new_amount = @account.amount + amount_params.to_i
      @account.update(amount: new_amount)
    end
    redirect_to accounts_url
  end

  private

  def amount_params
    params[:account][:amount]
  end

  # def find_account
  #   @user = User.find(params[:user_id])
  #   @account = @user.accounts.find(params[:account_id])
  # end
end
