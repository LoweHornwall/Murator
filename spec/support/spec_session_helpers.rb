module SpecSessionHelpers
  def log_in(user)
    post login_path, params: { session: { email: user.email, 
      password: attributes_for(:user)[:password]} }
  end
end