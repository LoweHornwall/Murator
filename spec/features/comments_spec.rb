require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  given(:user) { create(:user, :activated) }
  given(:review) { create(:review, :with_comments) }

  before :each do
    feature_log_in user
    visit curation_page_review_path(review.curation_page, review)
  end

  scenario "viewing review" do
    review.comments.each do |comment|
      expect(page).to have_content comment.content
    end

  end

  scenario "posting review" do
    content = "Good stuff!"
    fill_in "Post your thoughts!", with: content
    click_button "Post Comment"

    expect(page).to have_content content
  end

end
