class ReleaseGroupsController < ApplicationController
  def search
    @search = Musicbrainz.list_release_groups(params[:search_term], 
      search_by: params[:search_by] || "artist",
      page: params[:page] || 0)

    respond_to do |format|
      format.js
    end
  end
end
