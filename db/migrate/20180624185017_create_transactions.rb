class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :operation
      t.integer :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
