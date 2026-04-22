class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :google_uid, uniqueness: true, allow_nil: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  def self.from_google_oauth!(auth)
    google_uid = auth.uid
    email_address = auth.info.email.to_s.strip.downcase

    raise ArgumentError, "Google OAuth response missing email" if email_address.blank?

    user = find_by(google_uid:) || find_by(email_address:)
    user ||= new(email_address:)

    user.google_uid ||= google_uid
    user.password = SecureRandom.base58(24) if user.new_record?
    user.save! if user.new_record? || user.changed?
    user
  end
end
