class Story < ApplicationRecord
  require "erb"
  require "fileutils"
  require "loofah"

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
    write_title_to_template
    write_content_to_template
    create_idml_file
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

  # takes story title and adds it to the title template
  def write_title_to_template
    template = "#{user_folder_path_versioned}/InDesign/Story_u2fc1.xml.erb"
    # pass template and content to ERB
    xml = parse_erb(template, title)
    # Create an XML file based on template and contents
    File.open("#{user_folder_path_versioned}/InDesign/Story_u2fc1.xml", "w") do |file|
      file.write(xml)
      file.close
    end
    # Move file into IDML folder, and delete original template file
    FileUtils.cp("#{user_folder_path_versioned}/InDesign/Story_u2fc1.xml", "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}/Stories")
    FileUtils.rm(template)
  end

  # take story content and add it to the content template
  def write_content_to_template
    # use Loofah.fragment(var).text to get the text between html tags

    drop_cap_template = "#{user_folder_path_versioned}/InDesign/Story_u32b4.xml.erb"
    story_content_template = "#{user_folder_path_versioned}/InDesign/Story_u326e.xml.erb"

    # accommodate drop cap logic and story content
    story_content_array = format_story_content
    # drop cap is the first letter of the first worked
    drop_cap = Loofah.xml_fragment(story_content_array[0]).text.first

    # TODO: Refactor with if (length > 1) do something else do the other thing. this will reduce the size of the else condition statement.
    if (Loofah.xml_fragment(story_content_array[0]).text.length == 1)
      # if the first letter is also a word... e.g "I"
      # drop the first element in the array, join array back into a string, ignore the first character of the string, and add a space
      story_content = story_content_array.drop(1).join(" ").prepend("", " ")
    elsif (Loofah.xml_fragment(story_content_array[0]).text.length > 1)
      # if the first word has more than a single letter... e.g. "Hello"
      # remove the first character after the <Content> tag (representing the drop cap), and do not add a space - drop cap and first word are the same word
      # "<Content>Paragraphs are the building blocks of papers.</Content><Br />"
      story_content = story_content_array.join(" ")
      story_content[9] = ""
      story_content
    end

    ##### drop cap #####
    # pass template and content to ERB
    xml = parse_erb(drop_cap_template, drop_cap)
    # Create an XML file based on template and contents
    File.open("#{user_folder_path_versioned}/InDesign/Story_u32b4.xml", "w") do |file|
      file.write(xml)
      file.close
    end
    # Move file into IDML folder, and delete original template file
    FileUtils.cp("#{user_folder_path_versioned}/InDesign/Story_u32b4.xml", "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}/Stories")
    FileUtils.rm(drop_cap_template)

    ##### story content #####
    # pass template and content to ERB
    xml = parse_erb(story_content_template, story_content)
    # Create an XML file based on template and contents
    File.open("#{user_folder_path_versioned}/InDesign/Story_u326e.xml", "w") do |file|
      file.write(xml)
      file.close
    end
    # Move file into IDML folder, and delete original template file
    FileUtils.cp("#{user_folder_path_versioned}/InDesign/Story_u326e.xml", "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}/Stories")
    FileUtils.rm(story_content_template)
  end

  def create_idml_file
    %x( cd "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}" && zip -X0 "mystorybooklet-#{user_id}-#{version_number}.idml" mimetype )
    %x( cd "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}" && zip -rDX9 "mystorybooklet-#{user_id}-#{version_number}.idml" * -x '*.DS_Store' -x mimetype )
    %x( cd "#{user_folder_path_versioned}/InDesign/mystorybooklet-#{user_id}-#{version_number}" && mv "mystorybooklet-#{user_id}-#{version_number}.idml" ../ )
  end

  private

  def format_story_content
    # split content based on newlines while replace p tags with content tags, and a br tag at the end of each element except the
    # first and last element.
    story_content = content.split("\n").map { |e| e.sub!("<p>", "<Content>"); e.sub!("</p>", "</Content><Br />")}
    story_content[-1].remove!("<Br />")
    story_content
  end

  def parse_erb(template, content)
    # process html entities (e.g. &ldquo;) with Loofah, and pass content to ERB template
    content = Loofah.xml_fragment(content).to_s
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
