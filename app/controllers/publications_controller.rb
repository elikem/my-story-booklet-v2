class PublicationsController < ApplicationController
  def ready_for_pdf_conversion
    @publications = Publication.where(publication_status: "7_ready_for_pdf_conversion")

    render json: @publications
  end

  def show_json
    @publication = Publication.find(params[:id])

    render json: @publication
  end

  def get_idml
    @publication = Publication.find(params[:id])

    send_file("#{@publication.idml_file_path}", type: "application/x-indesign", disposition: "attachment", stream: true, status: 200)
  end
end
