class CurationPage < ApplicationRecord
  validates :name, :description, :user_id, presence: true
  validates :name, length: { maximum: 64 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 255 }
  belongs_to :user
  has_many :reviews
  self.per_page = 10
end
