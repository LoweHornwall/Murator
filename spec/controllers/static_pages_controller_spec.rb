require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    before(:each) do 
      get :home
    end

    it "renders the home templage" do
      expect(response).to render_template(:home)
    end
  end
end