class Story < ApplicationRecord
  belongs_to :user

  validates :content, length: { maximum: 200 }
  validate :user_has_one_story_per_language

  # Custom validation methods
  def user_has_one_story_per_language
    if Story.where("user_id = ? AND language = ?", user_id, language).count > 0
      errors.add(:user_id, "already has a story in #{language}")
    end
  end
end
