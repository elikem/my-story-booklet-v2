class CreateIdmlJob < ApplicationJob
  queue_as :create_idml
  sidekiq_options retry: 5

  def perform(publication_id)
    publication = Publication.find(publication_id)
    publication.start
  end
end
