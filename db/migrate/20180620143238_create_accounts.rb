class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :currency
      t.integer :balance, default: 0
      t.timestamps
    end
    add_index :accounts, :user_id
  end
end
