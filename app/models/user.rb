class User < ApplicationRecord
  attr_accessor :activation_token
  before_save :email_downcase
  before_create :set_activation_token
  validates :name, presence: true, length: { maximum: 64 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }
  validates :password, presence: true, length: { in: 6..64 }, allow_nil: true
  has_secure_password

  def User.digest(string)
    BCrypt::Password.create(string)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns(activated: true)
  end

  private
    def email_downcase
      if email.present?
        email.downcase!
      end
    end

    def set_activation_token
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
