FactoryBot.define do
  sequence :rgid do |n|
    n.to_s + "1" * (36 - n.to_s.length)
  end

  factory :release_group do
    rgid 
    release "MyString"
    artist "MyString"
  end
end
