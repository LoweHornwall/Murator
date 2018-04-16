module SpecSessionHelpers
  def log_in(user)
    post login_path, params: { session: { email: user.email, 
      password: attributes_for(:user)[:password]} }
  end

  def activate(user)
    user.update_attribute(:activated, true)
  end

  def feature_log_in(user)
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end