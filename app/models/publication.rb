# == Schema Information
#
# Table name: publications
#
#  id                 :bigint           not null, primary key
#  publication_number :string
#  publication_status :string           default("")
#  publication_url    :string           default("")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  story_id           :bigint
#
# Indexes
#
#  index_publications_on_publication_number  (publication_number) UNIQUE
#  index_publications_on_story_id            (story_id)
#
# Foreign Keys
#
#  fk_rails_...  (story_id => stories.id)
#
class Publication < ApplicationRecord
  before_create :set_publication_number

  belongs_to :story

  # publishing steps to create the idml file
  def start
    # reset the publishing status so future attempts by ActiveJob/Sidekiq to republish the same
    # story starts with a clean slate (in terms of the publishing status).
    self.update(publication_status: "") unless self.publication_status.blank?
    create_home_folder # step 1
    create_publication_folder # step 2
  end

  # create user's folder w/ README.txt containing user's full name, country of residence and email address for a story is published
  # format: /storage/users/elikem@gmail.com
  def create_home_folder
    FileUtils.mkdir_p(home_folder_path) unless Dir.exists?(home_folder_path)
    File.open("#{home_folder_path}/README.txt", "w") do |file|
      file.write("#{self.story.user.first_name}, #{self.story.user.last_name} (#{self.story.user.country_of_residence}) \n")
      file.write("#{self.story.user.country_of_residence} \n")
      file.write("#{self.story.user.email}")
      file.close
    end

    # update the publication status to register completion of method task
    self.update(publication_status: "1_create_home_folder")
  end

  # create a publication folder for the user's story
  # format: /storage/users/elikem@gmail.com/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg
  def create_publication_folder
    # copy the template folder to home directory with a new name (publication_folder_name which is based on timestamp_and_publication_number)
    FileUtils.cp_r(template_folder_path, publication_folder_path)

    # rename idml template folder to include publication timestamp and number only if this folder does not exists
    # format: /storage/users/elikem@gmail.com/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg-mystorybooklet-english
    FileUtils.mv("#{publication_folder_path}/#{template_idml_folder_name}", "#{publication_folder_path}/#{idml_folder_name}") if Dir.exists?("#{publication_folder_path}/#{template_folder_name}")

    # update the publication status to register completion of method task
    self.update(publication_status: "2_create_user_story_template")
  end

  # create a url safe random number to assign to a publication
  def set_publication_number
    self.publication_number = SecureRandom.urlsafe_base64
  end

  # this triggers a process on the companion app to start pulling publications that are ready to converted from idml to pdf
  def self.ready_for_pdf_conversion
    url = "#{CONFIG["companion_app_base_url"]}/start-pdf-conversion-process"
    response = Typhoeus.get(url)

    unless response.code == "200"
      # log response
      Rails.logger.error "ERROR: Request to companion app failed (GET #{url}). HTTP Status Code #{response.code} at #{Time.now}"
    end
  end

  # user folder path
  # format: /storage/users/elikem@gmail.com
  def home_folder_path
    "#{Rails.root}/storage/users/#{self.story.user.email}"
  end

  # mystorybooklet template folder path
  # /lib/indesign-assets/mystorybooklet-english-idml
  def template_folder_path
    "#{Rails.root}/lib/indesign-assets/mystorybooklet-english-idml"
  end

  # folder name of the idml template within template folder
  # /lib/indesign-assets/mystorybooklet-english-idml/mystorybooklet-english
  def template_idml_folder_name
    "mystorybooklet-english"
  end

  # name and location of the idml template folder after it is renamed to include publication timestamp and publication number
  # the user idml template folder is located inside the publication folder
  def publication_folder_path
    "#{home_folder_path}/#{publication_folder_name}"
  end

  # the name of the idml folder within the publication folder in the user's home folder
  def idml_folder_name
    "#{timestamp_and_publication_number}-mystorybooklet-english"
  end

  def publication_folder_name
    timestamp_and_publication_number
  end

  # timestamp and publication number used for the publication folder
  # timestamp is derived from the time publication was created
  # publication number is a unique number
  # format: 2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg
  def timestamp_and_publication_number
    timestamp = self .created_at.strftime("%Y-%m-%d-%H-%-M-%S")
    publication_number = self.publication_number

    "#{timestamp}-#{publication_number}"
  end
end
