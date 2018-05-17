require 'rails_helper'
require './spec/support/spec_session_helpers'

RSpec.configure { |c| c.include SpecSessionHelpers }

RSpec.feature "Categories", type: :feature do
  given!(:categories) { create_list(:category, 3) }
  given(:first_category) { categories.first }
  given!(:curation_pages) { create_list(:curation_page, 5, categories: [first_category]) }


  scenario "viewing category index" do
    visit "/categories"

    categories.each do |category|
      expect(page).to have_link category.name
    end
  end

  scenario "viewing category" do
    visit "/categories"
    click_link first_category.name

    expect(current_path).to eq category_path(first_category)
    expect(page).to have_content first_category.name

    first_category.curation_pages.each do |curation_page|
      expect(page).to have_link curation_page.name
    end
  end
end
