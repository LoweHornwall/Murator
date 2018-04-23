FactoryBot.define do
  factory :review do
    content "MyText"
    rating 1
    curation_page
    release_group
  end

  trait :with_comments do
    after(:create) do |review, evaluator|
      create_list(:comment, 5, review: review)
    end
  end
end
