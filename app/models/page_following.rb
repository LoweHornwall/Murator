class PageFollowing < ApplicationRecord
  validates :user, :curation_page, presence: true

  belongs_to :user, counter_cache: true
  belongs_to :curation_page, counter_cache: true
end
