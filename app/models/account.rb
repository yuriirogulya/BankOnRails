class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, class_name: 'AccountHistory'

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  # validate :cannot_create_another_account_with_uah_currency, on: :create
  # validate :cannot_create_another_account_with_usd_currency, on: :create

  # def cannot_create_another_account_with_uah_currency
  #   if user.accounts.where(currency: 'UAH').exists?
  #     errors.add(:accounts, 'you already have UAH account')
  #   end
  # end

  # def cannot_create_another_account_with_usd_currency
  #   if user.accounts.where(currency: 'USD').exists?
  #     errors.add(:accounts, 'you already have USD account')
  #   end
  # end
end