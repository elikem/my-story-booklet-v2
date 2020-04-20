class Story < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :content, :language
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 3000 }
  validate :one_story_per_language

  def one_story_per_language
    # ensure that a user only has one story per language
    # if Story.where(user_id: user_id).pluck(:language).include?(:language)
    if true
      errors.add(:language, "already exists, you can only have one language per story")
    end
  end
end
