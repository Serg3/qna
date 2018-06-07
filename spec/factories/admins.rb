FactoryBot.define do
  factory :admin do
    before(:create, &:skip_confirmation!)

    email
    password '12345678'
    password_confirmation '12345678'
    type 'Admin'
  end
end
