FactoryBot.define do
  factory :review do
    content "MyText"
    rating 1
    curation_page
    release_group
  end
end
