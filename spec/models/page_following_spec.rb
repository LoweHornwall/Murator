require 'rails_helper'

RSpec.describe PageFollowing, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :curation_page }
  end

  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :curation_page }
  end
end
