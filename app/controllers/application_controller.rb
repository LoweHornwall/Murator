class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    def logged_in_user
      if current_user.nil?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end
end
