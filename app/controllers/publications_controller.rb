class PublicationsController < ApplicationController
  protect_from_forgery :except => [:update_publication_with_pdf]

  # these are the publications that are "ready for pdf conversion"
  def waiting_for_pdf_conversion
    @publications = Publication.where("publication_status = '7_ready_for_pdf_conversion' AND conversion_status = 'pending'")
    render json: @publications
  end

  # show json object for a publication
  def show_json
    @publication = Publication.find(params[:id])
    render json: @publication
  end

  # provide idml download link for a publication
  def show_idml
    @publication = Publication.find(params[:id])
    send_file("#{@publication.idml_file_path}", type: "application/x-indesign", disposition: "attachment", stream: true, status: 200)
  end

  # update publication record with pdf url and publication number from companion app
  def update_publication_with_pdf
    @publication = Publication.find_by_publication_number(publication_params[:publication_number])
    @publication.update(publication_status: "8_pdf_conversion_complete", pdf_url: publication_params[:pdf_url])

    # TODO: Sidekiq job to email the pdf to the user
    # This method receives the post request from the companion app.
    EmailPdfToUserJob.perform_later(@publication.id)
    # TODO: Download pdf file  using pdf url to /Out folder
    DownloadPdfFromCompanionJob.perform_later(@publication.id)
  end

  private

  def publication_params
    params.require(:publication).permit(:conversion_status, :publication_filename, :publication_number, :publication_status, :publication_url, :story_id, :pdf_url)
  end
end
