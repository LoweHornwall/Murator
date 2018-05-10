require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: @email, password: @password, 
    password_confirmation: @password, activated: true) }
  before :all do
    @email = "a@a.com" 
    @password = "123hej"
  end 

  describe "GET /login" do
    before :each do
      get login_path
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST /login" do
    context "when params valid" do
      before :each do
        post login_path, params: { session: { email: @email, password: @password } } 
      end
      it "should set session" do
        expect(session[:user_id]).to_not be_nil
      end 

      it "redirects to root" do
        expect(response).to redirect_to :root
      end

      it "does not set remember digest" do
        user.reload
        expect(user.remember_digest).to be_nil
      end

      it "does not set cookies" do
        expect(cookies[:user_id]).to be_nil
        expect(cookies[:remember_token]).to be_nil
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
      before :all do 
        @email2 = "b@b.com"
        create(:user, email: @email2, password: @password, 
               password_confirmation: @password, activated: false)
      end
      before :each do
        post login_path, params: { session: { email: @email2, password: @password } } 
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

    context "when remember me selected" do
      before :each do
        post login_path, params: { session: { email: @email, password: @password, 
            remember_me: "1"} }
      end

      it "should set remember digest" do
        user.reload
        expect(user.remember_digest).to_not be_nil
      end

      it "sets cookies" do
        expect(cookies[:user_id]).to_not be_nil
        expect(cookies[:remember_token]).to_not be_nil
      end
    end
  end

  describe "DELETE /logout" do
    before :each do 
      post login_path, params: { session: { email: @email, password: @password } } 
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
