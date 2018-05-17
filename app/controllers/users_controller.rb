class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @curation_pages = @user.curation_pages.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "Account created! activation email sent"
      @user.send_activation_email
      redirect_to root_url
    else
      render :new
    end
  end

  def followed
    @user = User.find(params[:id])
    @curation_pages = @user.followed_pages.paginate(page: params[:page])
  end

  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
