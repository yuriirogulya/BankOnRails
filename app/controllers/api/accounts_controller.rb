module Api
  class AccountsController < BaseController
    before_action :find_account, only: %i[show destroy]
    before_action :find_user, only: %i[index create]
    before_action :authenticate_user

    def all_accounts
      @accounts = Account.all
      render json: { accounts: @accounts }
    end

    def index
      render json: { accounts: @user.accounts }
    end

    def show
      render json: { account: @account }
    end

    def create
      account = @user.accounts.new(account_params)
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

    def find_user
      @user = User.find(params[:user_id])
    end

    def find_account
      @account = Account.find(params[:id])
    end
  end
end
