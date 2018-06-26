FactoryBot.define do
  factory :user do
    username { FFaker::Internet.user_name }
    email { "#{username}@example.com".downcase }
    password { FFaker::Internet.password }
  end
end
