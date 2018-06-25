class Transaction < ApplicationRecord
  belongs_to :account

  scope :by_user_id, ->(user_id) do
    a = Arel::Table.new(:accounts)
    joins(:account).where(a[:user_id].eq user_id)
  end
  
  scope :account_id, ->(account_id) { where(account_id: account_id) }
end
