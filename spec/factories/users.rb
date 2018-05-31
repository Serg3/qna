FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    before(:create, &:skip_confirmation!)

    email
    password '12345678'
    password_confirmation '12345678'
  end
end
