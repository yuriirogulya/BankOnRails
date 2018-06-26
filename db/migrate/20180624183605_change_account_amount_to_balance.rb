class ChangeAccountAmountToBalance < ActiveRecord::Migration[5.2]
  def change
    rename_column :accounts, :amount, :balance
  end
end
