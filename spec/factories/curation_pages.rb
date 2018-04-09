FactoryBot.define do
  sequence :name do |n|
    "name:#{n}"
  end

  factory :curation_page do
    user 
    name 
    description "MyText"

    trait :with_reviews do
      after(:create) do |curation_page, evaluator|
        create_list(:review, 5, curation_page: curation_page)
      end
    end
  end
end
