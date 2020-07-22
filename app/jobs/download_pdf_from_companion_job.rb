class DownloadPdfFromCompanionJob < ApplicationJob
  queue_as :download_pdf_from_companion

  def perform(publication_id)
    @publication = Publication.find(publication_id)
    
    # download pdf from companion app
    # user publication helpers to find the right location for each publication based on
    # the publication number.
    File.open("#{@publication.publication_folder_path}/#{@publication.pdf_publication_filename}", "wb") do |file|
      file.write HTTParty.get(@publication.pdf_url).body
    end
  end
end
