require 'rails_helper'

RSpec.describe CurationPage, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_length_of(:name).is_at_most(64) }
    it { is_expected.to validate_length_of(:description).is_at_most(255)}
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:reviews) }
    it { is_expected.to have_many(:page_followings).dependent(:destroy) }
    it { is_expected.to have_many(:followers) }
  end
end
