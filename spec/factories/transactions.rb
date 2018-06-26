FactoryBot.define do
  factory :transaction do
    operation { %w[Withdraw Deposit].sample }
    amount { rand(0..10_000) }
    account
  end
end
