module Api
  class TransactionsController < BaseController
    before_action :find_transaction, only: %i[destroy]
    before_action :authenticate_user
    has_scope :by_account_id, as: :account
    has_scope :by_user_id, as: :user

    def index
      @transactions = apply_scopes(Transaction).all
      render json: { transactions: @transactions }
    end

    def destroy
      if @transaction.destroy
        render json: { msg: 'Transaction was deleted' }
      else
        render json: { errors: @transaction.errors.full_messages }, status: :unprocessible_entity
      end
    end

    private

    def find_transaction
      @transaction = Transaction.find(params[:id])
    end
  end
end