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

  describe "POST /users" do
    context "when params valid" do
      it "creates a new user" do
        expect{ post users_path, params: { user: attributes_for(:user) } }
          .to change{ User.count }.by 1
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
