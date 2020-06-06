class PublicationsController < ApplicationController
  # these are the publications that are "ready for pdf conversion"
  def ready_for_pdf_conversion
    @publications = Publication.where(publication_status: "7_ready_for_pdf_conversion")

    render json: @publications
  end

  # show json object for a publication
  def show_json
    @publication = Publication.find(params[:id])

    render json: @publication
  end

  # provide idml download link for a publication
  def get_idml
    @publication = Publication.find(params[:id])

    send_file("#{@publication.idml_file_path}", type: "application/x-indesign", disposition: "attachment", stream: true, status: 200)
  end

  # notification from the companion app...there are pdfs to download
  def companion_app_has_pdfs_to_download
    # call service to get pdfs from companion app
  end
end
