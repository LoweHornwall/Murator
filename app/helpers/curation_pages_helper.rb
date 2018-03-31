module CurationPagesHelper
  def belongs_to_user?
    !current_user.curation_pages.find_by(id: params[:id]).nil? if current_user
  end
end
