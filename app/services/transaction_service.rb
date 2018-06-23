class TransactionService
  def initialize(params)
    @user = params[:user_id]
    @account = params[:account_id]
    @operation = params[:commit]
    @amount = params[:account][:amount].to_i
  end

  def perform
    if @operation == 'Withdraw'
      new_amount = current_account.amount - @amount
      current_account.update(amount: new_amount)
    elsif @operation == 'Deposit'
      new_amount = current_account.amount + @amount
      current_account.update(amount: new_amount)
    end
  end

  private

  def current_account
    Account.find(@account)
  end
end
