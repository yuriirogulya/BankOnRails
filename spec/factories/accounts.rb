FactoryBot.define do
  factory :account do
    user
    currency { %w[USD UAH].sample }
    balance { rand(10_000..20_000) }
  end
end
