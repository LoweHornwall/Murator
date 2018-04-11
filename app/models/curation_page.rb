class CurationPage < ApplicationRecord
  validates :name, :description, :user_id, presence: true
  validates :name, length: { maximum: 64 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 255 }
  belongs_to :user, counter_cache: true
  has_many :reviews
  has_many :page_followings, dependent: :destroy
  has_many :followers, through: :page_followings, source: :user
  self.per_page = 10
end
