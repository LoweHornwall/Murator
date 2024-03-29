class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in(@user)
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        flash[:success] = "Logged in as #{@user.name}"
        redirect_back_or root_url
      else
        flash[:danger] = "Account is not activated"
        render :new
      end
    else
      flash[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def sessions_params
      params.require(:session).permit(:email, :password)
    end
end
