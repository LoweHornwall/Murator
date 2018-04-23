class Comment < ApplicationRecord
  validates :content, :user_id, :review_id, presence: true
  validates :content, length: { maximum: 128 }

  belongs_to :user
  belongs_to :review

  self.per_page = 10
  default_scope { order(created_at: :desc) }
end
