class User < ApplicationRecord
  before_save :email_downcase
  validates :name, presence: true, length: { maximum: 64 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }
  validates :password, presence: true, length: { in: 6..64 }, allow_nil: true

  has_secure_password

  private
    def email_downcase
      if email.present?
        email.downcase!
      end
    end
end
