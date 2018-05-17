class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }, 
    length: { maximum: 64 }

  has_and_belongs_to_many :curation_pages
  self.per_page = 20
end
