class Profile < ApplicationRecord
  belongs_to :user

  validates :username, presence: true, uniqueness: true
  validates :user_id, uniqueness: true
  has_rich_text :bio
  has_one_attached :profile_picture
end
