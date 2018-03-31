require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it do
      should validate_length_of(:password)
        .is_at_least(6)
        .is_at_most(64)
    end
    it { should validate_uniqueness_of(:email).case_insensitive }
    it "is not valid without correct email format" do
      user = build(:user)
      invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_emails.each do |invalid_email|
        user.email = invalid_email
        expect(user).to_not be_valid
      end
    end
    it "is valid with correct email format" do
      user = build(:user, email: Faker::Internet.safe_email)  
      expect(user).to be_valid
    end
    it { should validate_length_of(:name).is_at_most(64) }
    it { should validate_length_of(:email).is_at_most(255) }
  end

  describe "associations" do
    it { is_expected.to have_many(:curation_pages) }
  end

  describe "callbacks" do
    it { is_expected.to callback(:email_downcase).before(:save) }
    it { is_expected.to callback(:set_activation_token).before(:create) }
  end

end
