class User < ApplicationRecord
  attr_reader :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.name_length_max}
  validates :email, presence: true,
    length: {maximum: Settings.email_length_max},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.password_length_min}

  before_save :downcase_email

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def current_user? user
    self == user
  end

  def forget
    update_attributes remember_digest: nil
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
