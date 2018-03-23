class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?("activation", params[:id])
      user.activate
      flash[:success] = "Account activated!"
      redirect_to :root #should probably redirect to user page once implemented
    else
      flash[:danger] = "Invalid activation token"
      redirect_to :root
    end
  end
end
