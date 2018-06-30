module Api
  class AccountsController < BaseController
    before_action :find_account, only: %i[show destroy]
    before_action :authenticate_user
    load_and_authorize_resource

    def index
      @accounts = current_user.accounts
      render json: { accounts: @accounts }
    end

    def show
      render json: { account: current_user.accounts.find(@account.id) }
    end

    def create
      account = current_user  .accounts.new(account_params)
      if account.save
        render json: { msg: 'Account was created' }, status: :created
      else
        render json: { errors: account.errors.full_messages }, status: :unprocessible_entity
      end
    end

    def destroy
      if @account.destroy
        render json: { msg: 'Account was deleted' }
      else
        render json: { errors: @account.errors.full_messages }, status: :unprocessible_entity
      end
    end

    def transaction
      amount = transaction_params[:amount]
      operation = transaction_params[:operation]
      account = params[:account_id]
      if TransactionService.new(operation, account, amount).perform
        TransactionService.new(operation, account, amount).write_logs
        render json: { msg: 'Your balance updated' }
      else
        render json: { msg: 'Something wrong' }
      end
    end

    private

    def account_params
      params.require(:account).permit(:currency)
    end

    def transaction_params
      params.require(:transaction).permit(:amount, :operation)
    end

    def find_account
      @account = Account.find(params[:id])
    end
  end
end
