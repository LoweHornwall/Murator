class CurationPagesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    if !params[:term].blank?
      @curation_pages = CurationPage.where('name LIKE ?', "#{params[:term]}")
        .order(curation_page_order).paginate(page: params[:page])
    else
      @curation_pages = CurationPage.all.order(curation_page_order)
        .paginate(page: params[:page])
    end
  end

  def show
    @curation_page = CurationPage.find(params[:id])
    @reviews = @curation_page.reviews.includes(:curation_page, :release_group)
      .paginate(page: params[:page])
  end

  def new
    @all_categories = Category.all
    @curation_page = CurationPage.new
  end

  def create
    @all_categories = Category.all
    @curation_page = current_user.curation_pages.build(curation_page_params)
    if @curation_page.save
      flash[:success] = "Curation page created!"
      redirect_to @curation_page
    else
      render :new
    end
  end

  def followers
    @curation_page = CurationPage.find(params[:id])
    @followers = @curation_page.followers.paginate(page: params[:page])
  end

  private
    def curation_page_params
      params.require(:curation_page).permit(:name, :description, :selected_categories)
    end

    def correct_user
      @curation_page = current_user.curation_pages.find_by(id: params[:id])
      if @curation_page.nil?
        redirect_to root_url
      end
    end

    def curation_page_order
      case params[:order_by]
      when "oldest"
        "created_at ASC"
      when "name"
        "name"
      when "followers"
        "page_followings_count DESC"
      when "reviews"
        "reviews_count DESC"
      else
        "created_at DESC"
      end
    end
end
