class PageFollowingsController < ApplicationController
  before_action :logged_in_user
  def create
    @curation_page = CurationPage.find(params[:curation_page_id])
    current_user.follow(@curation_page)
    respond_to do |format|
      format.html { redirect_to @curation_page }
      format.js
    end
  end
  
  def destroy
    @curation_page = PageFollowing.find(params[:id]).curation_page
    current_user.unfollow(@curation_page)
    respond_to do |format|
      format.html { redirect_to @curation_page }
      format.js
    end
  end
end
