class PublicationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(story_id, publication_id)
    story = Story.find(story_id)
    publication = Publication.find(publication_id)

    story.publish(publication)
  end
end