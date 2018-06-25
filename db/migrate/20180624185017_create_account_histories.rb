class CreateAccountHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :account_histories do |t|
      t.string :operation
      t.integer :amount
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
