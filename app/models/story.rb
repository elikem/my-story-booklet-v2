class Story < ApplicationRecord
  belongs_to :user

  validates :content, length: { maximum: 3000 }
  # validate :user_has_one_story_per_language, on: :create
  validate :one_story_per_user_per_language, on: create

  # Custom validation methods
  def user_has_one_story_per_language
    if Story.where("user_id = ? AND language = ?", user_id, language).count > 0
      errors.add(:user_id, "can only have one story in #{language}")
    end
  end

  def one_story_per_user_per_language

  end
end
