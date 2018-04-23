class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :update, :destroy]
  before_action :review_exists, only: [:create, :update, :destroy]
  before_action :belongs_to_user, only: [:update, :destroy]
  
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created!"
    else
      flash[:danger] = "Invalid comment"
    end
    redirect_to curation_page_review_path(@review.curation_page, @review)
  end

  def update
  end

  def destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :review_id)
    end

    def review_exists 
      @review = Review.find_by(id: params[:comment][:review_id])
      if @review.nil?
        redirect_to root_url
      end
    end

    def belongs_to_user
      @comment = current_user.comments.find_by(id: params[:id])
      if @comment.nil?
        redirect_to root_url
      end
    end
end
