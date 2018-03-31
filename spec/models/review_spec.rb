require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:curation_page_id) }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..10) }
    it "enforces uniqueness scoped to release group" do
      create(:review)
      is_expected.to validate_uniqueness_of(:curation_page)
        .scoped_to(:release_group_id) # shoulda matchers breaks if _id is not used
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:curation_page) }
    it { is_expected.to belong_to(:release_group) }
  end
end
