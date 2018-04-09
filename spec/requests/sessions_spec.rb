require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  before :all do
    @email = "a@a.com" 
    @password = "123hej"
    create(:user, email: @email, password: @password, 
      password_confirmation: @password, activated: true) 
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
