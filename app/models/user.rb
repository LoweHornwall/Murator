class User < ApplicationRecord
  attr_accessor :activation_token, :reset_token, :remember_token
  before_save :email_downcase
  before_create :set_activation_token
  validates :name, presence: true, length: { maximum: 64 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }
  validates :password, presence: true, length: { in: 6..64 }, allow_nil: true
  has_secure_password
  has_many :curation_pages
  has_many :page_followings, dependent: :destroy
  has_many :followed_pages, through: :page_followings, source: :curation_page
  has_many :comments
  self.per_page = 20
  
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

  def create_reset_digest 
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(self.reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def activate
    update_columns(activated: true)
  end

  def follow(curation_page)
    followed_pages << curation_page unless following?(curation_page)
  end

  def unfollow(curation_page)
    followed_pages.delete(curation_page)
  end

  def following?(curation_page)
    followed_pages.include?(curation_page)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    Review.includes(:curation_page, :release_group)
      .where("curation_page_id IN (SELECT curation_page_id FROM
        page_followings WHERE user_id = :user_id)", user_id: id)
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
