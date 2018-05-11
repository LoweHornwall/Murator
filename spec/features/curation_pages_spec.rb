require 'rails_helper'
require './spec/support/spec_session_helpers'

RSpec.configure { |c| c.include SpecSessionHelpers }

RSpec.feature "CurationPages", type: :feature do
  given!(:curation_pages) { create_list(:curation_page, 15) }
  given!(:cp_with_reviews) { create(:curation_page, :with_reviews) }
  given(:user) { create(:user, :activated, :with_curation_pages) }

  scenario "viewing first page of curation pages" do
    visit "/curation_pages"
    click_link("oldest")
    (0..9).each do |i|
      expect(page).to have_link curation_pages[i].name
    end
  end

  scenario "viewing second page of curation pages" do
    visit "/curation_pages"
    click_link("oldest")
    first(:link, "Next →").click
    (10..14).each do |i|
      expect(page).to have_link curation_pages[i].name
    end
  end

  scenario "viewing curation page with reviews" do
    visit "/curation_pages"
    click_link("oldest")
    first(:link, "Next →").click
    click_link cp_with_reviews.name

    expect(page).to have_content cp_with_reviews.name
    expect(page).to have_content cp_with_reviews.description
    expect(page).to have_content "Created by #{cp_with_reviews.user.name}"

    review = cp_with_reviews.reviews.first
    review_string = "#{review.release_group.release} by #{review.release_group.artist}"
    expect(page).to have_content review_string
  end

  scenario "view users pages" do
    feature_log_in user
    visit "/"
    click_link "Your Pages"

    curation_pages = user.curation_pages
    expect(current_path).to eq user_path(user)
    expect(page).to have_content curation_pages.first.name
    expect(page).to have_link "Create new curation page"
  end

  scenario "view curation page form" do
    feature_log_in user
    visit user_path(user)
    click_link "Create new curation page"

    expect(current_path).to eq new_curation_page_path
  end

  scenario "creating curation page" do
    feature_log_in user
    visit new_curation_page_path

    name = "foo"
    description = "bar"
    fill_in "Name", with: name
    fill_in "Description", with: description
    click_button "Create curation page"

    expect(current_path).to eq curation_page_path(CurationPage.last)
    expect(page).to have_content "Curation page created!"
    expect(page).to have_content name
    expect(page).to have_content description
    expect(page).to have_content "Created by #{user.name}"
  end

  scenario "searching for curation page" do
    visit curation_pages_path

    curation_page_name = user.curation_pages.first.name
    fill_in "Search Curation Pages", with: curation_page_name
    click_button "Search"

    expect(page).to have_content curation_page_name
  end
end
