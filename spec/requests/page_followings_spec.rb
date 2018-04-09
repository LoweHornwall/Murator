require 'rails_helper'

RSpec.describe "PageFollowings", type: :request do
  let(:user) { create(:user, :activated) }
  let(:curation_page) { create(:curation_page) }
  describe "POST /page_followings" do
    context "when user logged in and params valid" do
      before :each do
        log_in user
      end
      it "redirects to curation page" do
        post page_followings_path, params: { curation_page_id: curation_page.id }
        expect(response).to redirect_to curation_page
      end
      it "creates a new page following for user" do 
        expect{
          post page_followings_path, params: { curation_page_id: curation_page.id }
        }.to change{ user.followed_pages.count }.by 1
      end
    end

    context "when params invalid and logged in" do
      before :each do
        log_in user
      end

      it "raises RecordNotFound error" do
        expect{
          post page_followings_path, params: { curation_page_id: 1337 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when not logged in" do
      before :each do
        post page_followings_path, params: { curation_page_id: curation_page.id }
      end
      it { is_expected.to redirect_to login_path }
    end
  end

  describe "DELETE /page_followings" do
    let(:user) { create(:user, :activated, :with_page_followings) }
    let(:curation_page) { user.followed_pages.first }
    context "when params valid and logged in" do
      before :each do 
        log_in user
      end
      it "redirect to curation page" do
        delete page_following_path(curation_page.id)
        expect(response).to redirect_to curation_page
      end

      it "deletes page following from user" do
        expect{
          delete page_following_path(curation_page.id)
          }.to change{ user.followed_pages.count}.by -1
      end
    end

    context "when not logged in" do
      before :each do
        delete page_following_path(curation_page.id)
      end

      it { is_expected.to redirect_to login_path }
    end

    context "when trying to unfollow page that user is not following" do
      let(:other_user) { create(:user, :activated, :with_page_followings) }
      let(:other_curation_page) { other_user.followed_pages.first }
      before :each do
        log_in user
      end

      it "does not change users followings" do
        expect{
          delete page_following_path(other_curation_page.id)
        }.to change{ user.followed_pages.count }.by 0
      end

      it "does not remove other users followings" do
        expect {
          delete page_following_path(curation_page.id)
          }.to change{ other_user.followed_pages.count }.by 0
      end
    end
  end
end
