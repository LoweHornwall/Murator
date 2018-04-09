class Review < ApplicationRecord
  attr_accessor :rgid, :selected_release_name
  validates :content, :rating, :curation_page_id, presence: true
  validates :rating, inclusion: { in: (1..10) }
  validates :content, length: { maximum: 1000 }
  validates :curation_page, uniqueness: { scope: :release_group_id } # _id for shoulda matchers
  belongs_to :curation_page
  belongs_to :release_group
  default_scope { order(created_at: :desc) }
  self.per_page = 5

  # move to controller layer?
  def assign_release_group
    if release_group = ReleaseGroup.find_by(rgid: self.rgid) 
      self.release_group = release_group
      #current_tags = Musicbrainz.display_release_group(self.rgid)[:tags] # if tags changed since last time relase was reviewed
      #self.release_group.add_tags(current_tags)
    elsif release_group = Musicbrainz.display_release_group(self.rgid)
      created_group = ReleaseGroup.create!(release_group.except(:tags))
      self.release_group = created_group
    end
  end
end
