class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user,   only: [:new, :create]

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
end
