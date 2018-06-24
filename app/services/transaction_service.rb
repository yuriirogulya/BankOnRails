class TransactionService
  def initialize(operation, account, amount)
    @operation = operation
    @account = account
    @amount = amount
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
