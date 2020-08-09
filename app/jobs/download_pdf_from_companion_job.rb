class DownloadPdfFromCompanionJob < ApplicationJob
  queue_as :download_pdf_from_companion

  def perform(publication_id)
    @publication = Publication.find(publication_id)
    
    # download pdf from companion app
    # user publication helpers to find the right location for each publication based on
    # the publication number.
    
    pdf_file_path = "#{@publication.publication_folder_path}/#{@publication.pdf_publication_filename}"

    File.open(pdf_file_path, "wb") do |file|
      file.write HTTParty.get(@publication.pdf_url).body
    end

    @publication.update(pdf_file_path: pdf_file_path, conversion_status: "complete")
  end
end
