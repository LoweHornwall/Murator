FactoryBot.define do
  factory :user do
    name Faker::Internet.user_name
    email Faker::Internet.safe_email
    password "password"
    password_confirmation "password"

    trait :activated do
      activated true
    end
  end
end
