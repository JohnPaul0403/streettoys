class Post < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :user

  has_many_attached :images
  has_rich_text :description
end
