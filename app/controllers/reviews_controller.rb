class ReviewsController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,    only: [:new, :create, :edit, :update, :destroy]
  before_action :belongs_to_user, only: [:edit, :update, :destroy]

  def show
    @review = Review.includes(:curation_page).find(params[:id])
  end

  def new
    @review = @curation_page.reviews.build
  end

  def create
    @review = @curation_page.reviews.build(review_params)
    @review.assign_release_group
    if @review.save
      flash[:success] = "Review created!"
      redirect_to @curation_page
    else
      render :new
    end
  end

  def edit
  end

  def update
    @review.update_attributes(review_params)
    @review.assign_release_group
    if @review.save
      flash[:success] = "Review updated!"
      redirect_to curation_page_review_path(@review.curation_page, @review)
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:success] = "Review deleted"
    redirect_to @review.curation_page
  end

  private
    def review_params
      params.require(:review).permit(:rgid, :content, :rating, 
                                     :selected_release_name)
    end

    def correct_user
      @curation_page = current_user.curation_pages.find_by(id: params[:curation_page_id])
      if @curation_page.nil?
        redirect_to root_url
      end
    end

    def belongs_to_user
      @review = @curation_page.reviews.includes(:curation_page).find_by(id: params[:id])
      if @review.nil?
        redirect_to root_url
      end
    end
end
