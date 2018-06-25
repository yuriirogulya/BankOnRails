class AccountHistoriesController < ApplicationController
  has_scope :account_id

  def index
    @account_histories = apply_scopes(AccountHistory).by_user_id(current_user)
  end

  def destroy
    @account_history = AccountHistory.find(params[:id])
    @account_history.destroy
    redirect_to account_histories_path
  end
end
