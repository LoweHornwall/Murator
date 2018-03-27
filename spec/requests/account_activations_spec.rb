require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /edit_account_activation" do
    context "with valid token" do
      let(:user) { create(:user) }
      before :each do
        get edit_account_activation_path(user.activation_token, email: user.email)
      end
      it "flashes success" do
        expect(flash[:success]).to_not be_nil
      end

      it "activates user" do
        user.reload       
        expect(user.activated?).to eql(true)
      end

      it "redirects to user" do
        expect(response).to redirect_to user
      end
    end

    context "with invalid token" do
      let(:user) { create(:user) }
      before :each do
        get edit_account_activation_path("foo", email: user.email)
      end

      it "flashes danger" do
        expect(flash[:danger]).to_not be_nil
      end

      it "does not activate user" do
        user.reload
        expect(user.activated?).to eql(false)
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end
  end
end
