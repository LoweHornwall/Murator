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

    trait :with_curation_pages do
      after(:create) do |user, evaluator|
        create_list(:curation_page, 5, user: user)
      end
    end
  end
end
