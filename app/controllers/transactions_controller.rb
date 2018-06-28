class TransactionsController < ApplicationController
  has_scope :by_account_id, as: :account

  def index
    @transactions = apply_scopes(Transaction).by_user_id(current_user)
  end

  def destroy
    @account_history = Transaction.find(params[:id])
    @account_history.destroy
    redirect_to transactions_path
  end
end
