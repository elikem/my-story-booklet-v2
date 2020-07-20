class CreateIdmlJob < ApplicationJob
  queue_as :create_idml

  def perform(publication_id)
    publication = Publication.find(publication_id)
    publication.start
  end
end
