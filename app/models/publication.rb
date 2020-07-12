# == Schema Information
#
# Table name: publications
#
#  id                   :bigint           not null, primary key
#  conversion_status    :string           default("pending")
#  pdf_file             :binary
#  publication_filename :string           default("")
#  publication_number   :string
#  publication_status   :string           default("")
#  publication_url      :string           default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  story_id             :bigint
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
  require "loofah"

  before_create :set_publication_number

  belongs_to :story

  # publishing steps to create the idml file
  def start
    # reset the publishing status so future attempts by ActiveJob/Sidekiq to republish the same
    # story starts with a clean slate (in terms of the publishing status).
    self.update(publication_status: "") unless self.publication_status.blank?
    create_home_folder # step 1
    create_publication_folder # step 2
    write_title_to_publication # step 3
    write_drop_cap_to_publication # step 4
    write_content_to_publication # step 5
    create_idml # step 6 and # step 7 - ready for pdf conversion is a ghost step purely for semantic reasons
    # inform companion app of a pdf ready for conversion.
  end

  # create idml file in the user's idml folder
  def create_idml
    # go into the user's idml folder path and create a zip file with the mimetype without compressing the mimetype. this will allow InDesign to recognize it as a valid InDesign file
    %x( cd "#{idml_folder_path}" && zip -X0 "#{idml_folder_path}/#{publication_filename}" mimetype  )
    # add all the other files into the previously create zip file except DS_Store and mimetype
    %x( cd "#{idml_folder_path}" && zip -rDX9 "#{idml_folder_path}/#{publication_filename}" * -x '*.DS_Store' -x mimetype  )
    # move the idml file up a level
    %x( cd "#{idml_folder_path}" && mv "#{idml_folder_path}/#{publication_filename}" .. )

    # update the publication status to register completion of method task
    # update the publication url - GET /publications/:id/idml(.:format)
    self.update(publication_status: "6_create_idml", publication_url: "#{CONFIG["core_app_domain"]}/publications/#{self.id}/idml", publication_filename: publication_filename)

    # this status change is more for semantic reasons. it is at this point that publication is ready for pdf conversion.
    # the mystorybooklet companion app will be notified of an available publication and pull them down into a hot folder for conversion.
    self.update(publication_status: "7_ready_for_pdf_conversion")

    # pass idml publication details to companion app
    post_idml_publication_to_companion
  end

  # take story content and add it to the content template
  def write_content_to_publication
    story_content_template = "#{mystorybooklet_english_template_files}/#{story_content_erb_filename}"

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

    # pass template and content to e
    xml = parse_erb(story_content_template, story_content)

    # Create an XML file based on template and contents
    File.open("#{publication_folder_path}/#{story_content_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # copy file into idml folder
    FileUtils.cp("#{publication_folder_path}/#{story_content_xml_filename}", "#{idml_folder_path}/Stories/#{story_content_xml_filename}")

    # update the publication status to register completion of method task
    self.update(publication_status: "5_write_content_to_template")
  end

  # take drop cap and add it to the drop cap template
  def write_drop_cap_to_publication
    drop_cap_template = "#{mystorybooklet_english_template_files}/#{drop_cap_erb_filename}"

    # drop cap is the first letter of the first worked
    drop_cap = Loofah.xml_fragment(formatted_story_content[0]).text.first

    # pass template and content to erb
    xml = parse_erb(drop_cap_template, drop_cap)

    # Create an xml file based on template and contents
    File.open("#{publication_folder_path}/#{drop_cap_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # copy file into idml folder
    FileUtils.cp("#{publication_folder_path}/#{drop_cap_xml_filename}", "#{idml_folder_path}/Stories/#{drop_cap_xml_filename}")

    # update the publication status to register completion of method task
    self.update(publication_status: "4_write_drop_cap_to_template")
  end

  # take story title and adds it to the title publication
  def write_title_to_publication
    template = "#{mystorybooklet_english_template_files}/#{title_erb_filename}"

    # pass template and content to ERB
    xml = parse_erb(template, story.title)

    # create an xml file based on template and contents
    File.open("#{publication_folder_path}/#{title_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # copy file into idml folder
    FileUtils.cp("#{publication_folder_path}/#{title_xml_filename}", "#{idml_folder_path}/Stories/#{title_xml_filename}")

    # update the publication status to register completion of method task
    self.update(publication_status: "3_write_title_to_template")
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
    FileUtils.mv("#{publication_folder_path}/#{template_idml_folder_name}", "#{publication_folder_path}/#{idml_folder_name}") if Dir.exists?("#{publication_folder_path}/#{template_idml_folder_name}")

    # update the publication status to register completion of method task
    self.update(publication_status: "2_create_user_story_template")
  end

  # create a url safe random number to assign to a publication
  def set_publication_number
    self.publication_number = SecureRandom.urlsafe_base64
  end

  # this triggers a process on the companion app to start pulling the publication that is ready to convert from idml to pdf
  # the companion server will receive this request and download the idml
  # the response should have a parameter that indicates successful download
  # TODO: this should be offloaded to another Sidekiq worker - this request will wait for the companion app to download and respond w/ 200 and some other parameter
  def post_idml_publication_to_companion
    response = HTTParty.post(publish_idml_publication, query: { publication: { publication_number: publication_number, publication_url: publication_url, publication_filename: publication_filename }})

    # Status Code 204 - No Content
    unless response.code == "204"
      # log response
      Rails.logger.error "ERROR: (GET #{publish_idml_publication}). HTTP Status Code #{response.code} at #{Time.now}"
    end
  end

  # url to post idml publication
  def publish_idml_publication
    "#{CONFIG["companion_app_domain"]}/publish-idml-publication"
  end

  # accommodate drop cap logic and story content
  # split content based on newlines while replace p tags with content tags, and a br tag at the end of each element except the
  # first and last element.
  def formatted_story_content
    story_content = story.content.split("\n").map { |e| e.sub!("<p>", "<Content>"); e.sub!("</p>", "</Content><Br />") }
    story_content[-1].remove!("<Br />")
    story_content
  end

  # idml file path
  def idml_file_path
    "#{publication_folder_path}/#{idml_folder_name}.idml"
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
  # format: /storage/users/elikem@gmail.com/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg
  def publication_folder_path
    "#{home_folder_path}/#{publication_folder_name}"
  end

  # the name of the idml folder within the publication folder in the user's home folder
  # format: 2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg-mystorybooklet-english
  def idml_folder_name
    "#{timestamp_and_publication_number}-mystorybooklet-english"
  end

  # the path to the idml folder
  # format: /storage/users/elikem@gmail.com/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg/2020-05-19-03-26-23-lZAo3JDDYJGkbnqtcycGyg-mystorybooklet-english
  def idml_folder_path
    "#{publication_folder_path}/#{idml_folder_name}"
  end

  # the name of the publication folder
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

  # mystorybooklet template files
  # refers to the exact xml files that make up the title, drop cap, and content of the story
  def mystorybooklet_english_template_files
    "#{Rails.root}/lib/indesign-assets/mystorybooklet-english-template-files"
  end

  # add content to erb template and return processed erb file
  def parse_erb(template, content)
    # process html entities (e.g. &ldquo;) with Loofah, and pass content to ERB template
    content = Loofah.xml_fragment(content).to_s
    ERB.new(File.read("#{template}")).result(binding)
  end

  # set the publication filename
  def publication_filename
    "#{idml_folder_name}.idml"
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
