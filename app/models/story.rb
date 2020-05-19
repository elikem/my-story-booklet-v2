class Story < ApplicationRecord
  require "erb"
  require "fileutils"
  require "loofah"

  before_save :story_title_should_be_uppercase

  belongs_to :user
  has_many :publications

  validates_presence_of :title, :content, :language
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 3000 }
  validate :one_story_per_language, on: :create



  # publishing steps to create idml file
  # you can only have a single story in the publication pipeline
  # as such references to a publication will also point to the most recent one
  def publish
    # create a publication for user story, the publication auto-generates the publication number (which should be unique)
    Publication.create!(story_id: id)

    create_user_folder
    create_user_story_template
    write_title_to_template
    write_drop_cap_to_template
    write_content_to_template
  end

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

  # create folder w/ README.txt containing user's full name, country of residence and email address for a story is published
  # format: elikem@gmail.com (the folder name is the email address of the user)
  def create_user_folder
    FileUtils.mkdir_p(user_folder_path) unless Dir.exists?(user_folder_path)
    File.open("#{user_folder_path}/README.txt", "w") do |file|
      file.write("#{user.first_name}, #{user.last_name} (#{user.country_of_residence}) \n")
      file.write("#{user.email}")
      file.close
    end
  end

  # create a template for the user's story
  # format: /storage/users/elikem@gmail.com/[timestamp]_[publication_number] e.g. 2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg
  def create_user_story_template
    # copy template folder to user's folder with timestamp
    FileUtils.cp_r(mystorybooklet_template_folder, user_template_folder_path)

    # rename idml folder w/ publication timestamp and number
    FileUtils.mv("#{user_template_folder_path}/mystorybooklet-english", user_idml_folder_path)
  end

  # take story title and adds it to the title template
  def write_title_to_template
    template = "#{user_template_folder_path}/#{title_erb_filename}"
    # pass template and content to ERB
    xml = parse_erb(template, title)

    # create an xml file based on template and contents
    File.open("#{user_template_folder_path}/#{title_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # move file into idml folder, and delete original template file
    FileUtils.cp("#{user_template_folder_path}/#{title_xml_filename}", "#{user_idml_folder_path}/Stories/#{title_xml_filename}")
    FileUtils.rm(template)
  end

  # take drop cap and add it to the drop cap template
  def write_drop_cap_to_template
    drop_cap_template = "#{user_template_folder_path}/#{drop_cap_erb_filename}"

    # drop cap is the first letter of the first worked
    drop_cap = Loofah.xml_fragment(formatted_story_content[0]).text.first

    # pass template and content to erb
    xml = parse_erb(drop_cap_template, drop_cap)

    # Create an xml file based on template and contents
    File.open("#{user_template_folder_path}/#{drop_cap_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # Move file into idml folder, and delete original template file
    FileUtils.cp("#{user_template_folder_path}/#{drop_cap_xml_filename}", "#{user_idml_folder_path}/Stories/#{drop_cap_xml_filename}")
    FileUtils.rm(drop_cap_template)
  end

  # take story content and add it to the content template
  def write_content_to_template
    story_content_template = "#{user_template_folder_path}/#{story_content_erb_filename}"

    if (Loofah.xml_fragment(formatted_story_content[0]).text.length == 1)
      # if the first letter is also a word... e.g "I"
      # drop the first element in the array, join array back into a string, ignore the first character of the string, and add a space
      story_content = formatted_story_content.drop(1).join(" ").prepend("", " ")
    else
      # if the first word has more than a single letter... e.g. "Hello" (length > 1 is assumed based on falseness of the if statement above)
      # remove the first character after the <Content> tag (representing the drop cap), and do not add a space - drop cap and first word are the same word
      # "<Content>Paragraphs are the building blocks of papers.</Content><Br />"
      story_content = formatted_story_content.join(" ")
      # Remove the first character of the first word
      story_content[9] = ""
      # output revised story content
      story_content
    end

    # pass template and content to erb
    xml = parse_erb(story_content_template, story_content)

    # Create an XML file based on template and contents
    File.open("#{user_template_folder_path}/#{story_content_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # Move file into idml folder, and delete original template file
    FileUtils.cp("#{user_template_folder_path}/#{story_content_xml_filename}", "#{user_idml_folder_path}/Stories/#{story_content_xml_filename}")
    FileUtils.rm(story_content_template)
  end

  # accommodate drop cap logic and story content
  # split content based on newlines while replace p tags with content tags, and a br tag at the end of each element except the
  # first and last element.
  def formatted_story_content
    story_content = content.split("\n").map { |e| e.sub!("<p>", "<Content>"); e.sub!("</p>", "</Content><Br />")}
    story_content[-1].remove!("<Br />")
    story_content
  end

  # add content to erb template and return processed erb file
  def parse_erb(template, content)
    # process html entities (e.g. &ldquo;) with Loofah, and pass content to ERB template
    content = Loofah.xml_fragment(content).to_s
    ERB.new(File.read("#{template}")).result(binding)
  end

  # mystorybooklet template folder path
  # /lib/assets/mystorybooklet-english
  def mystorybooklet_template_folder
    "#{Rails.root}/lib/assets/mystorybooklet-english"
  end

  # user folder path
  # format: storage/users/elikem@gmail.com
  def user_folder_path
    "#{Rails.root}/storage/users/#{user.email}"
  end

  # user story folder path
  # format: /storage/users/elikem@gmail.com/[timestamp (utc)]_[publication_number]
  def user_template_folder_path
    "#{user_folder_path}/#{timestamp_and_publication_number}-idml-assets"
  end

  # name and location of the idml template folder after it is renamed to include publication timestamp and numnber
  def user_idml_folder_path
    "#{user_template_folder_path}/#{timestamp_and_publication_number}"
  end

  # timestamp and publication number used for the publication folders and the idml folder and filename
  # timestamp is derived from the time publication was created
  # format: 2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg
  def timestamp_and_publication_number
    timestamp = publications.last.created_at.strftime("%Y-%m-%d-%H-%-M-%S")
    publication_number = publications.last.publication_number

    "#{timestamp}-#{publication_number}"
  end

  # filename for title erb file
  def title_erb_filename
    "Story_u2fc1.xml.erb"
  end

  # filename for the title xml file
  def title_xml_filename
    "Story_u2fc1.xml"
  end

  # filename for drop cap erb file
  def drop_cap_erb_filename
    "Story_u32b4.xml.erb"
  end

  # filename for the drop cap xml file
  def drop_cap_xml_filename
    "Story_u32b4.xml"
  end

  # filename for story content erb file
  def story_content_erb_filename
    "Story_u326e.xml.erb"
  end

  # filename for the story content xml file
  def story_content_xml_filename
    "Story_u326e.xml"
  end
end