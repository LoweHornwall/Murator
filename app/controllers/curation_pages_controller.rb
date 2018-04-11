class CurationPagesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  def index
    @curation_pages = CurationPage.all.paginate(page: params[:page])
  end

  def show
    @curation_page = CurationPage.find(params[:id])
    @reviews = @curation_page.reviews.includes(:curation_page, :release_group)
      .paginate(page: params[:page])
  end

  def new
    @curation_page = CurationPage.new
  end

  def followers
    curation_page = CurationPage.find(params[:id])
    @followers = curation_page.followers.paginate(page: params[:page])
  end

  def create
    @curation_page = current_user.curation_pages.build(curation_page_params)
    if @curation_page.save
      flash[:success] = "Curation page created!"
      redirect_to @curation_page
    else
      render :new
    end
  end

  private
    def curation_page_params
      params.require(:curation_page).permit(:name, :description)
    end
end
