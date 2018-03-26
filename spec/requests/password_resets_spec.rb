require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "GET /password_resets/new" do
    before :each do
      get new_password_reset_path
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST /password_resets" do
    context "with valid params" do
      let (:user) { create(:user) }
      before :each do
        post password_resets_path, params:  { password_reset: { 
          email: user.email } }
      end

      it "sets reset_digest" do
        user.reload
        expect(user.reset_digest).to_not be_nil
      end

      it "sends reset email" do
        expect(ActionMailer::Base.deliveries.size).to eql 1
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end

      it "flashes success" do
        expect(flash[:success]).to eql "Password reset email sent!"
      end
    end
    context "with invalid params" do
      before :each do
        post password_resets_path, params: { password_reset: { 
          email: Faker::Internet.safe_email } }
      end

      it "renders new" do
        expect(response).to render_template :new
      end

      it "flashes danger" do
        expect(flash[:danger]).to eql "Email adress not found"
      end
    end
  end

  describe "GET /password_resets/:id/edit" do
    context "with valid params" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it "renders the edit template" do
        expect(response).to render_template :edit
      end
    end

    context "with invalid email" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        get edit_password_reset_path(user.reset_token, 
                                     email: Faker::Internet.safe_email)
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end

    context "with invalid token" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        get edit_password_reset_path("123", 
                                     email: user.email)
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end
    context "with inactive user" do
      let (:user) { create(:user) }
      before :each do
        user.create_reset_digest
        get edit_password_reset_path(user.reset_token, 
                                     email: user.email)
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end
    context "with expired token" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        get edit_password_reset_path(user.reset_token, 
                                     email: user.email)
      end

      it "flashes danger" do
        expect(flash[:danger]).to eql "Reset has expired"
      end

      it "redirects to new" do
        expect(response).to redirect_to new_password_reset_url
      end
    end
  end

  describe "PATCH /password_resets/:id" do
    context "with valid params" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobar",
            password_confirmation: "foobar"
          }
        }
      end

      it "updates password" do
        expect(user.password_digest).to_not eql user.reload.password_digest
      end

      it "flashes success" do
        expect(flash[:success]).to eql "Password has been updated"
      end

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end
    context "with empty password in params" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "",
            password_confirmation: "foobar"
          }
        }
      end
      it "has error" do
        expect(response.body).to match "error"
      end

      it "renders edit" do
        expect(response).to render_template :edit
      end
    end
    context "with inactive user" do
      let (:user) { create(:user) }
      before :each do
        user.create_reset_digest
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobar",
            password_confirmation: "foobar"
          }
        }
      end
      it { is_expected.to redirect_to :root }
    end

    context "with expired token" do
      let (:user) { create(:user, :activated) }
      before :each do
        user.create_reset_digest
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token), params: {
          email: user.email,
          user: {
            password: "foobar",
            password_confirmation: "foobar"
          }
        }
      end
      it { is_expected.to redirect_to new_password_reset_url }
      it "flashes danger" do
        expect(flash[:danger]).to eql "Reset has expired"
      end
    end
  end
end
