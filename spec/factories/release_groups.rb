FactoryBot.define do
  sequence :rgid do |n|
    "1" * 35 + n.to_s
  end

  factory :release_group do
    rgid 
    release "MyString"
    artist "MyString"
  end
end
