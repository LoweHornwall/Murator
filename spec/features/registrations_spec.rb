require 'rails_helper'

RSpec.feature "Registrations", type: :feature do
  given(:user_name) { Faker::Internet.user_name }
  given(:email) { Faker::Internet.safe_email }
  given(:password) {Faker::Internet.password }

  scenario "viewing registration screen" do
    visit "/"
    click_link "Register"

    expect(current_path).to eq new_user_path
    expect(page).to have_content "Sign up!"
  end

  scenario "Registration with valid params" do
    visit "users/new"
    register(user_name, email, password)

    expect(current_path).to eq root_path
    expect(page).to have_content "Account created! activation email sent"
  end

  scenario "Registration with taken params" do
    2.times  do 
      visit "users/new"
      register(user_name, email, password)
    end

    expect(current_path).to eq users_path
    expect(page).to have_content "Email has already been taken"
  end

  scenario "Registration with invalid user name" do
    visit "users/new"
    register("", email, password)

    expect(current_path).to eq users_path
    expect(page).to have_content "Name can't be blank"
  end
end

def register(user_name, email, password)
  fill_in "Name", with: user_name
  fill_in "Email", with: email
  fill_in "Password", with: password
  fill_in "Confirmation", with: password
  click_button "Create account"
end
