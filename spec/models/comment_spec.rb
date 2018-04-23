require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:review_id) }
    it { is_expected.to validate_length_of(:content).is_at_most(128) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:review) }
    it { is_expected.to belong_to(:user) }
  end
end
