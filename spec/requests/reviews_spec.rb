require 'rails_helper'
require './spec/support/spec_session_helpers'

RSpec.configure { |c| c.include SpecSessionHelpers }

RSpec.describe "Reviews", type: :request do
  describe "GET /curation_pages/:curation_page_id/reviews/new" do
    let(:user)  { create(:user, :activated, :with_curation_pages) }
    let(:curation_page) { user.curation_pages.first }
    context "when logged in" do
      before :each do
        log_in user
        get new_curation_page_review_path(curation_page)
      end
      it { is_expected.to render_template :new }
    end
    context "when logged out" do
      before :each do
        get new_curation_page_review_path(curation_page)
      end
      it { is_expected.to redirect_to :login }
      it "flashed danger" do
        expect(flash[:danger]).to eql "Please log in"
      end 
    end
  end

  describe "POST /curation_pages/:curation_page_id/reviews" do
    let(:user) { create(:user, :activated, :with_curation_pages) }
    let(:curation_page) { user.curation_pages.first } 
    let(:release_group) { create(:release_group) } # create release group to avoid calling API in test
    context "when valid params and logged in" do
      before :each do
        log_in user
      end
      it "create new review" do
        expect {
          post curation_page_reviews_path(curation_page), params: {
            review: attributes_for(:review, rgid: release_group.rgid) }
        }.to change { Review.count }.by 1
      end

      it "redirects to curation page" do
        post curation_page_reviews_path(curation_page), params: {
          review: attributes_for(:review, rgid: release_group.rgid) }
        expect(response).to redirect_to curation_page
      end
    end

    context "valid params but not logged in" do
      it "redirects to login page" do
        post curation_page_reviews_path(curation_page), params: {
          review: attributes_for(:review, rgid: release_group.rgid) }
        expect(response).to redirect_to :login
      end
    end

    context "with invalid params" do
      before :each do
        log_in user
        post curation_page_reviews_path(curation_page), params: {
          review: attributes_for(:review, rgid: release_group.rgid, rating: -1)
        }
      end
      it { is_expected.to render_template :new }
    end
  end
end
