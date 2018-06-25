class AccountHistoriesController < ApplicationController
  def index
    @account_histories = AccountHistory.by_user_id(current_user.id)
  end

  def destroy
    @account_history = AccountHistory.find(params[:id])
    @account_history.destroy
    redirect_to account_histories_path
  end
end
