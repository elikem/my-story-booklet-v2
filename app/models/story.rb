# == Schema Information
#
# Table name: stories
#
#  id         :bigint           not null, primary key
#  content    :text
#  language   :string
#  status     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_stories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Story < ApplicationRecord
  before_save :story_title_should_be_uppercase

  belongs_to :user
  has_many :publications, dependent: :destroy

  validates_presence_of :title, :content, :language
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 3000 }
  validate :one_story_per_language, on: :create

  private

  # story title should be upper case
  def story_title_should_be_uppercase
    title.upcase!
  end

  # Validation to ensure that a user only has one story per language
  def one_story_per_language
    if Story.where(user_id: user_id).pluck(:language).include?(language)
      errors.add(:language, "error. An #{language} story already exists, you can only have one language per story")
    end
  end
end
