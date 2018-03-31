class ReleaseGroup < ApplicationRecord
  validates :rgid, :release, :artist, presence: true
  validates :rgid, uniqueness: true, length: { is: 36 }
  validates :release, :artist, length: { maximum: 255 }
  has_many :reviews
end
