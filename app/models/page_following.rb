class PageFollowing < ApplicationRecord
  validates :user, :curation_page, presence: true

  belongs_to :user
  belongs_to :curation_page
end
