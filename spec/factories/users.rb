FactoryBot.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    name Faker::Internet.user_name
    email
    password "password"
    password_confirmation "password"

    trait :activated do
      activated true
    end
  end
end
