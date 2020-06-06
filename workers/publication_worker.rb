class PublicationWorker
  include Sidekiq::Worker
  sidekiq_options queue: "idml_publications"

  def perform(publication_id)
    publication = Publication.find(publication_id)
    publication.start
  end
end
