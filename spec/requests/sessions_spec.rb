require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    before :each do
      get login_path
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST /login" do
    EMAIL = "a@a.com"
    PASSWORD = "123hej"
    before :all do
      create(:user, email: EMAIL, password: PASSWORD, 
             password_confirmation: PASSWORD, activated: true)
    end

    context "when params valid" do
      before :each do
        post login_path, params: { session: { email: EMAIL, password: PASSWORD } } 
      end
      it "should set session" do
        expect(session[:user_id]).to_not be_nil
      end 

      it "redirects to root" do
        expect(response).to redirect_to :root
      end
    end

    context "when params invalid" do
      before :each do 
        post login_path, params: { session: { email: "foo", password: "bar" } }
      end

      it "should not set session" do
        expect(session[:user_id]).to be_nil
      end

      it "flashes danger" do
        expect(flash[:danger]).to_not be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end

    context "when params valid but user not activated" do
      EMAIL2 = "b@b.com"
      before :all do 
        create(:user, email: EMAIL2, password: PASSWORD, 
               password_confirmation: PASSWORD, activated: false)
      end
      before :each do
        post login_path, params: { session: { email: EMAIL2, password: PASSWORD } } 
      end

      it "should not set session" do
        expect(session[:user_id]).to be_nil
      end

      it "flashes danger" do
        expect(flash[:danger]).to_not be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE /logout" do
    before :each do 
      post login_path, params: { session: { email: EMAIL2, password: PASSWORD } } 
      delete logout_url
    end

    it "deletes user_id session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root" do
      expect(response).to redirect_to :root
    end
  end
end
