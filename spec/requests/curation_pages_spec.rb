require 'rails_helper'
require './spec/support/spec_session_helpers'

RSpec.configure do |c|
  c.include SpecSessionHelpers
end

RSpec.describe "CurationPages", type: :request do
  describe "GET /curation_pages" do
    before :each do
      get curation_pages_path
    end
    it { is_expected.to render_template :index}
  end

  describe "GET /curation_pages/:id" do
    let(:curation_page) { create :curation_page }
    before :each do
      get curation_page_path(curation_page)
    end
    it { is_expected.to render_template :show }
    it "shows curation page name and description" do
      expect(response.body).to match curation_page.name
      expect(response.body).to match curation_page.description
    end
  end

  describe "GET /curation_pages/new" do
    context "when logged in" do
      let(:user) { create(:user, :activated) }
      before :each do
        log_in user
        get new_curation_page_path
      end
      it { is_expected.to render_template :new}
    end
    context "when not logged in" do
      before :each do
        get new_curation_page_path
      end
      it { is_expected.to redirect_to login_url }
      it "flashes danger" do
        expect(flash[:danger]).to eql "Please log in"
      end
    end
  end

  describe "POST /curation_pages" do
    context "when params valid and logged in" do
      let(:user) { create(:user, :activated) }
      before :each do
        log_in user
      end
      it "creates new curation page" do
        expect { post curation_pages_path, params: { 
          curation_page: attributes_for(:curation_page) } 
          }.to change { CurationPage.count }.by 1
      end
      it "redirects to curation_page" do
        post curation_pages_path, params: { 
          curation_page: attributes_for(:curation_page) }
        expect(response).to redirect_to assigns(:curation_page)
      end
    end
    context "when params invalid" do
      let(:user) { create(:user, :activated) }
      before :each do
        log_in user
        post curation_pages_path, params: { 
          curation_page: attributes_for(:curation_page, name: "") }
      end
      it { is_expected.to render_template :new}
      it "shows errors" do
        expect(response.body).to match "error"
      end
    end
    context "when not logged in" do
      let(:user) { create(:user, :activated) }
      before :each do
        post curation_pages_path, params: { 
          curation_page: attributes_for(:curation_page) }
      end
      it { is_expected.to redirect_to login_url }
      it "flashes danger" do
        expect(flash[:danger]).to eql "Please log in"
      end
    end
  end
end
