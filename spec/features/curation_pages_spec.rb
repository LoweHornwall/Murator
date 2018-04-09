require 'rails_helper'

RSpec.feature "CurationPages", type: :feature do
  given!(:curation_pages) { create_list(:curation_page, 15) }
  given!(:cp_with_reviews) { create(:curation_page, :with_reviews) }
  given(:user) { create(:user, :with_curation_pages) }

  scenario "viewing first page of curation pages" do
    visit "/curation_pages"
    (0..9).each do |i|
      expect(page).to have_link curation_pages[i].name
    end
  end

  scenario "viewing second page of curation pages" do
    visit "/curation_pages"
    click_link "Next →"
    (10..14).each do |i|
      expect(page).to have_link curation_pages[i].name
    end
  end

  scenario "viewing curation page with reviews" do
    visit "curation_pages"
    click_link "Next →"
    click_link cp_with_reviews.name

    expect(page).to have_content cp_with_reviews.name
    expect(page).to have_content cp_with_reviews.description
    expect(page).to have_content "Created by #{cp_with_reviews.user.name}"

    review = cp_with_reviews.reviews.first
    review_string = "#{review.release_group.release} by #{review.release_group.artist}"
    expect(page).to have_content review_string
  end
end
