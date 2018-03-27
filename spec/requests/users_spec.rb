require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    before :each do
      get new_user_path
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET /users/:id" do
    let(:user) { create :user }
    before :each do
      get user_path(user)
    end

    it { is_expected.to render_template :show}
    it "shows user name" do
      expect(response.body).to match user.name
    end
  end

  describe "POST /users" do
    context "when params valid" do
      it "creates a new user" do
        expect{ post users_path, params: { user: attributes_for(:user) } }
          .to change{ User.count }.by 1
      end

      it "sends activation email" do
        post users_path, params: { user: attributes_for(:user) }
        expect(ActionMailer::Base.deliveries.size).to eql 1
      end

      it "redirects to root" do
        post users_path, params: { user: attributes_for(:user) }
        expect(response).to redirect_to :root
      end
    end

    context "when params invalid" do
      it "does not create new user" do
        expect {
          post users_path, params: { user: { name: "", email: ".com",
                password: "123", password_confirmation: "321" } } 
        }.to change{ User.count }.by 0
      end

      it "renders the new template" do
        post users_path, params: { user: { name: "", email: ".com",
              password: "123", password_confirmation: "321" } } 
        expect(response).to render_template :new
      end
    end
  end
end
