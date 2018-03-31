require 'rails_helper'

RSpec.describe ReleaseGroup, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:rgid) }
    it { is_expected.to validate_presence_of(:release) }
    it { is_expected.to validate_presence_of(:artist) }
    it { is_expected.to validate_uniqueness_of(:rgid) }
    it { is_expected.to validate_length_of(:rgid).is_equal_to(36) }
    it { is_expected.to validate_length_of(:release).is_at_most(255) }
    it { is_expected.to validate_length_of(:artist).is_at_most(255) }
  end

  describe "associations" do
    it { is_expected.to have_many(:reviews) }
  end
end
