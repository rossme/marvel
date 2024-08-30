# spec/factories/advisors.rb

FactoryBot.define do
  factory :user do
    email { "email@example.com" }
    password { :password_digest }
    created_at { DateTime.now }
  end
end
