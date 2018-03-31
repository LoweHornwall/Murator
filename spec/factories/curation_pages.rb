FactoryBot.define do
  sequence :name do |n|
    "name:#{n}"
  end

  factory :curation_page do
    user 
    name 
    description "MyText"
  end
end
