class PublicationsController < ApplicationController
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
end
