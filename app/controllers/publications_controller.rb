class PublicationsController < ApplicationController
  def ready_for_pdf_conversion
    @publications = Publication.where(publication_status: "7_ready_for_pdf_conversion")

    render json: @publications
  end
end
