require 'rails_helper'

RSpec.feature "Logins", type: :feature do
  let(:email) { Faker::Internet.safe_email }
  let(:password) { Faker::Internet.password }
  scenario "User logs in with correct details" do
    user = create(:user, :activated, email: email, password: password, 
                  password_confirmation: password)

    visit "/"
    click_link "Log in"
    expect(current_path).to eq login_path
    expect(page).to have_css("h1", text: "Log in!")
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
    expect(current_path).to eql root_path
    expect(page).to have_css("h1", text: "Welcome #{user.name}!")
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_link("Your Pages")

    click_link "Log out"
    expect(current_path).to eql root_path
    expect(page).to have_link("Log in")
    expect(page).to_not have_css("h1", text: "Welcome #{user.name}!") 
  end

  scenario "unactivated user attempts to log in" do
    create(:user, email: email, password: password, 
           password_confirmation: password)
    visit "/login"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
    expect(current_path).to eql login_path
    expect(page).to have_content("Account is not activated")
  end

  scenario "user attempts to log in with invalid email/password combination" do
    user = create(:user, :activated, email: email, password: password, 
              password_confirmation: password)
    visit "/login"
    fill_in "Email", with: "foo"
    fill_in "Password", with: "bar"
    click_button "Log in"
    expect(current_path).to eql login_path
    expect(page).to have_content("Invalid email/password combination")
  end
end
