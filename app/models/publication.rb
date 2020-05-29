# == Schema Information
#
# Table name: publications
#
#  id                 :bigint           not null, primary key
#  publication_number :string
#  publication_status :text             default([]), is an Array
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

  # create a url safe random number
  def set_publication_number
    self.publication_number = SecureRandom.urlsafe_base64
  end

  # assign a publication status (an array) to the attribute
  def self.update_publication_status(publication_id, status)
    publication = Publication.find(publication_id)
    # shorthand to assign the status to the existing publication status (in the database) and send to the variable
    publication_status = publication.publication_status << status
    publication.update_attributes(publication_status: publication_status)
  end
end
