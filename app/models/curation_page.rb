class CurationPage < ApplicationRecord
  attr_accessor :selected_categories
  before_validation :add_categories

  validates :name, :description, :user_id, presence: true
  validates :name, length: { maximum: 64 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 255 }
  belongs_to :user, counter_cache: true
  has_many :reviews
  has_many :page_followings, dependent: :destroy
  has_many :followers, through: :page_followings, source: :user
  has_and_belongs_to_many :categories
  self.per_page = 10

  private
    def add_categories
      return if selected_categories.blank?
      categories_arr = JSON.parse(selected_categories)
      categories_arr.each do |id|
        category = Category.find_by(id: id)
        if (category)
          categories << category unless categories.include?(category)
        else
          errors.add(:selected_categories, :blank, 
            message: "Invalid") if category.nil?
        end
      end
    end
end
