module CurationPagesHelper
  def belongs_to_user?
    !current_user.curation_pages.find_by(id: params[:id]).nil? if current_user
  end

  def curation_page_order
    order = ""
    case params[:order_by]
    when "created_at ASC"
      order = "created_at ASC"
    when "name"
      order = "name"
    when "followers"
      order = "page_followings_count DESC"
    when "reviews"
      order = "reviews_count DESC"
    else
      order = "created_at DESC"
    end
    return order
  end
end
