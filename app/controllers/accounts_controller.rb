class AccountsController < ApplicationController
  before_action :find_account, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def show; end

  private

  def find_account
    @user = User.find(params[:user_id])
    @account = @user.accounts.find(params[:id])
  end
end
