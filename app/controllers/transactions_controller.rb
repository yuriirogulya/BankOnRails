class TransactionsController < ApplicationController
  has_scope :account_id

  def index
    @transactions = apply_scopes(Transaction).by_user_id(current_user)
  end

  def destroy
    @account_history = Transaction.find(params[:id])
    @account_history.destroy
    redirect_to account_histories_path
  end
end
