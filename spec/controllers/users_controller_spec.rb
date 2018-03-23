require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before :each do
      get :new
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "assigns @user" do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "when params valid" do
      subject { post :create, params: { user: attributes_for(:user) } }

      it "creates a new item" do
        expect{subject}.to change{ User.count }.by(1)
      end

      it "redirects to the home page" do
        expect(subject).to redirect_to(root_url)
      end


    end
    context "when params invalid" do
      subject { post :create, params: { user: { name: "", email: ".com",
                password: "123", password_confirmation: "321" } } }

      it "doesn't create a new item" do
        expect{subject}.to change{ User.count }.by(0)
      end

      it "renders the new template" do
        expect(subject).to render_template(:new)
      end
    end
  end
end
