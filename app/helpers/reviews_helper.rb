module ReviewsHelper
  def cover_art_for(rgid)
    url = Coverartarchive.get_cover_art(rgid)
    if url
      image_tag(url)
    else
      "No Img found"
    end
  end
end
