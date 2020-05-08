class Story < ApplicationRecord
  require "erb"
  require "fileutils"

  before_save :story_title_should_be_uppercase

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

  # publishing steps to create IDML file
  def publish
    create_user_folder
    copy_template_to_user_folder
    write_story_title_to_template
  end

  # create folder w/ README.txt containing user's full name, country of residence and email address for a story is published
  def create_user_folder
    FileUtils.mkdir_p(user_folder_path) unless Dir.exists?(user_folder_path)
    File.open("#{user_folder_path}/README.txt", "w") do |file|
      file.write("#{user.first_name}, #{user.last_name} (#{user.country_of_residence}) \n")
      file.write("#{user.email}")
      file.close
    end
  end

  # copy template to user folder
  def copy_template_to_user_folder
    # create folder for publication version
    FileUtils.mkdir("#{user_folder_path_versioned}")
    # copy template folder to user's folder
    FileUtils.cp_r("#{template_path}", "#{user_folder_path_versioned}")
    # add version number to template folder, format: mystorybooklet-user-id-version-number
    FileUtils.mv("#{user_folder_path_versioned}/InDesign/mystorybooklet",
                 "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}")
  end

  # takes story title and adds it to the story template
  def write_story_title_to_template
    title_template = "#{user_folder_path_versioned}/InDesign/Story_u2fc1.xml.erb"
    story_title_xml_file = parse_erb(title_template, title)
    File.open("#{title_template}", "w") do |file|
      file.write(story_title_xml_file)
      file.close
    end

    # raise language
    # overwrite story title xml file
    # make story tile upcase on entry using validation
  end

  private

  def parse_erb(template, content)
    ERB.new(File.read("#{template}")).result(binding)
  end

  # folder format: /storage/{user_id}
  def user_folder_path_versioned
    "#{user_folder_path}/#{version_number}"
  end

  # story title should be upper case
  def story_title_should_be_uppercase
    title.upcase!
  end

  # template path
  def template_path
    "#{Rails.root}/lib/assets/InDesign"
  end

  # folder format: /storage/{user_id}
  def user_folder_path
    "#{Rails.root}/storage/users/#{user_id}"
  end
end
