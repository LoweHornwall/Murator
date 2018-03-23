require 'rails_helper'
include SessionsHelper
RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    before(:each) do
      get :new
    end 

    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    EMAIL = "a@a.com"
    PASSWORD = "123hej"
    before :all do
      create(:user, email: EMAIL, password: PASSWORD, 
             password_confirmation: PASSWORD)

    end
    context "when params valid" do
      before :each do
        post :create, params: { session: { email: EMAIL, password: PASSWORD } } 
      end
      it { should set_session }
      it { should set_flash }
      it "redirects to the home page" do
        expect(response).to redirect_to(:root)
      end
    end

    context "when params invalid" do
      before :each do 
        post :create, params: { session: { email: "foo", password: "bar" } } 
      end
      it "has errors" do
        expect(flash[:danger]).not_to be_empty                                                    
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      log_in(User.first)   
      delete :destroy
    end 
    it "deletes user_id session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the home page" do
      expect(response).to redirect_to(:root)
    end
  end
end
