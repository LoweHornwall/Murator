require 'rails_helper'
require "./spec/support/spec_session_helpers"

RSpec.configure { |c| c.include SpecSessionHelpers }

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user, :activated) }
  let(:review) { create(:review) }
  describe "POST /comments" do
    context "with valid params and when logged in" do
      before :each do
        log_in user
      end
      it "creates a new comment for review" do
        expect { post comments_path, params: {  
          comment: { review_id: review.id, content: "foo"} }
        }.to change { review.comments.count }.by 1
      end

      it "redirects to review" do
        post comments_path, params: {  
          comment: { review_id: review.id, content: "foo"} }
        expect(response).to redirect_to curation_page_review_path(review.curation_page, review)
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post comments_path, params: {  
          comment: { review_id: review.id, content: "foo"} }
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid params" do
      before :each do
        log_in user
      end

      it "does not create a new comment for review" do
        expect { post comments_path, params: {  
          comment: { review_id: review.id, content: ""} }
        }.to change { review.comments.count }.by 0
      end

      it "renders " do
        post comments_path, params: {  
          comment: { review_id: review.id, content: ""} }
        expect(response).to render_template "reviews/show"
      end
    end
  end
end
