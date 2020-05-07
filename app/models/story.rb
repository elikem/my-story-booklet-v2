class Story < ApplicationRecord
  require 'erb'
  require 'fileutils'

  belongs_to :user

  validates_presence_of :title, :content, :language
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 3000 }
  validate :one_story_per_language, on: :create

  # Validation to ensure that a user only has one story per language
  def one_story_per_language
    if Story.where(user_id: user_id).pluck(:language).include?(language)
      errors.add(:language, "error. An #{language} story already exists, you can only have one language per story")
    end
  end

  # publishing steps
  def publish
    create_user_folder
  end

  # create folder w/ README.txt containing user's full name, country of residence and email address for a story is published
  def create_user_folder
    FileUtils.mkdir_p(folder_path) unless Dir.exists?(folder_path)
    File.open("#{folder_path}/README.txt", "w") do |file|
      file.write("#{self.user.first_name}, #{self.user.last_name} (#{self.user.country_of_residence}) \n")
      file.write("#{self.user.email}")
      file.close
    end
  end

  # folder format: /storage/{user_id}
  def folder_path
    user_id = self.user.id
    storage_path = "#{Rails.root}/storage/users/#{user_id}"
  end
end
