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
  require "erb"
  require "fileutils"
  require "loofah"

  before_save :story_title_should_be_uppercase

  belongs_to :user
  has_many :publications, dependent: :destroy

  validates_presence_of :title, :content, :language
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 3000 }
  validate :one_story_per_language, on: :create


  def publish(publication)


    write_title_to_template(publication) # step 3
    write_drop_cap_to_template(publication) # step 4
    write_content_to_template(publication) # step 5
    create_idml(publication) # step 6 and # step 7 - ready for pdf conversion is a ghost step purely for semantic reasons
    # inform companion app of a pdf ready for conversion.
    Publication.ready_for_pdf_conversion
  end

  # idml file path
  def idml_file_path(publication)
    "#{user_template_folder_path(publication)}/#{timestamp_and_publication_number(publication)}.idml"
  end

  # filename of the idml file
  def idml_filename(publication)
    "#{timestamp_and_publication_number(publication)}.idml"
  end

  # private

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

  # take story title and adds it to the title template
  def write_title_to_template(publication)
    template = "#{mystorybooklet_english_template_files}/#{title_erb_filename}"

    # pass template and content to ERB
    xml = parse_erb(template, title)

    # create an xml file based on template and contents
    File.open("#{user_template_folder_path(publication)}/#{title_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # move file into idml folder
    FileUtils.cp("#{user_template_folder_path(publication)}/#{title_xml_filename}", "#{user_template_idml_folder_path(publication)}/Stories/#{title_xml_filename}")

    # update the publication status to register completion of method task
    publication.update(publication_status: "3_write_title_to_template")
  end

  # take drop cap and add it to the drop cap template
  def write_drop_cap_to_template(publication)
    drop_cap_template = "#{mystorybooklet_english_template_files}/#{drop_cap_erb_filename}"

    # drop cap is the first letter of the first worked
    drop_cap = Loofah.xml_fragment(formatted_story_content[0]).text.first

    # pass template and content to erb
    xml = parse_erb(drop_cap_template, drop_cap)

    # Create an xml file based on template and contents
    File.open("#{user_template_folder_path(publication)}/#{drop_cap_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # move file into idml folder
    FileUtils.cp("#{user_template_folder_path(publication)}/#{drop_cap_xml_filename}", "#{user_template_idml_folder_path(publication)}/Stories/#{drop_cap_xml_filename}")

    # update the publication status to register completion of method task
    publication.update(publication_status: "4_write_drop_cap_to_template")
  end

  # take story content and add it to the content template
  def write_content_to_template(publication)
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
    File.open("#{user_template_folder_path(publication)}/#{story_content_xml_filename}", "w") do |file|
      file.write(xml)
      file.close
    end

    # Move file into idml folder
    FileUtils.cp("#{user_template_folder_path(publication)}/#{story_content_xml_filename}", "#{user_template_idml_folder_path(publication)}/Stories/#{story_content_xml_filename}")

    # update the publication status to register completion of method task
    publication.update(publication_status: "5_write_content_to_template")
  end

  # create idml file in the user's idml folder
  def create_idml(publication)
    # go into the user's idml folder path and create a zip file with the mimetype without compressing the mimetype. this will allow InDesign to recognize it as a valid InDesign file
    %x( cd "#{user_template_idml_folder_path(publication)}" && zip -X0 "#{timestamp_and_publication_number(publication)}.idml" mimetype  )
    # add all the other files into the previously create zip file except DS_Store and mimetype
    %x( cd "#{user_template_idml_folder_path(publication)}" && zip -rDX9 "#{timestamp_and_publication_number(publication)}.idml" * -x '*.DS_Store' -x mimetype  )
    # move the idml file up a level
    %x( cd "#{user_template_idml_folder_path(publication)}" && mv "#{timestamp_and_publication_number(publication)}.idml" ..  )

    # update the publication status to register completion of method task
    # update the publication url - GET /publications/:id/idml(.:format)
    publication.update(publication_status: "6_create_idml", publication_url: "#{CONFIG["base_url"]}/publications/#{publication.id}/idml")

    # this status change is more for semantic reasons. it is at this point that publication is ready for pdf conversion.
    # the mystorybooklet companion app will be notified of an available publication and pull them down into a hot folder for conversion.
    publication.update(publication_status: "7_ready_for_pdf_conversion")
  end

  # accommodate drop cap logic and story content
  # split content based on newlines while replace p tags with content tags, and a br tag at the end of each element except the
  # first and last element.
  def formatted_story_content
    story_content = content.split("\n").map { |e| e.sub!("<p>", "<Content>"); e.sub!("</p>", "</Content><Br />") }
    story_content[-1].remove!("<Br />")
    story_content
  end

  # add content to erb template and return processed erb file
  def parse_erb(template, content)
    # process html entities (e.g. &ldquo;) with Loofah, and pass content to ERB template
    content = Loofah.xml_fragment(content).to_s
    ERB.new(File.read("#{template}")).result(binding)
  end



  # mystorybooklet template files
  # refers to the exact xml files that make up the title, drop cap, and content of the story
  def mystorybooklet_english_template_files
    "#{Rails.root}/lib/indesign-assets/mystorybooklet-english-template-files"
  end

  # user folder path
  # format: storage/users/elikem@gmail.com
  def user_folder_path
    "#{Rails.root}/storage/users/#{user.email}"
  end

  # user story folder path
  # this folder contains the user idml folder path
  def user_template_folder_path(publication)
    "#{user_folder_path}/#{timestamp_and_publication_number(publication)}-idml-assets"
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
