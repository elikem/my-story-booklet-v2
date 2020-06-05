class PublicationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(publication_id)
    publication = Publication.find(publication_id)
    publication.start
  end
end
