require 'rails_helper'

RSpec.feature "Logins", type: :feature do
  EMAIL = Faker::Internet.safe_email
  PASSWORD = Faker::Internet.password
  scenario "with correct details" do
    user = create(:user, :activated, email: EMAIL, password: PASSWORD, 
                  password_confirmation: PASSWORD)

    visit "/"
    click_link "Log in"
    expect(current_path).to eq login_path
    expect(page).to have_css("h1", text: "Log in!")
    fill_in "Email", with: EMAIL
    fill_in "Password", with: PASSWORD
    click_button "Log in"
    expect(current_path).to eql root_path
    expect(page).to have_css("h1", text: "Welcome #{user.name}!")
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_link("Your pages")

    click_link "Log out"
    expect(current_path).to eql root_path
    expect(page).to have_link("Log in")
    expect(page).to_not have_css("h1", text: "Welcome #{user.name}!") 
  end

  scenario "unactivated user cannot login" do
    create(:user, email: EMAIL, password: PASSWORD, 
           password_confirmation: PASSWORD)
    visit "/login"
    fill_in "Email", with: EMAIL
    fill_in "Password", with: PASSWORD
    click_button "Log in"
    expect(current_path).to eql login_path
    expect(page).to have_content("Account is not activated")
  end

  scenario "invalid email/password combination" do
    user = create(:user, :activated, email: EMAIL, password: PASSWORD, 
              password_confirmation: PASSWORD)
    visit "/login"
    fill_in "Email", with: "foo"
    fill_in "Password", with: "bar"
    click_button "Log in"
    expect(current_path).to eql login_path
    expect(page).to have_content("Invalid email/password combination")
  end
end
