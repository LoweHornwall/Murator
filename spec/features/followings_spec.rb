require 'rails_helper'
require './spec/support/spec_session_helpers'

RSpec.configure { |c| c.include SpecSessionHelpers }

RSpec.feature "Followings", type: :feature do
  let(:user) { create(:user, :activated) }
  let!(:curation_page) { create(:curation_page, :with_reviews) } 

  scenario "follow curation page" do
    feature_log_in user
    visit "/"
    click_link "Curation Pages"

    click_link curation_page.name
    click_button "Follow"
    expect(current_path).to eql curation_page_path(curation_page)
    expect(page).to have_button("Unfollow")

    visit "/"
    expect(page).to have_selector('.reviews')

    click_link "Curation Pages"
    click_link curation_page.name
    click_button "Unfollow"
    expect(current_path).to eql curation_page_path(curation_page)
    expect(page).to have_button("Follow") 

    visit "/"
    expect(page).to_not have_selector(".reviews")   
  end 
end
