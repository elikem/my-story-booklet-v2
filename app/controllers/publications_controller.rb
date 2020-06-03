class PublicationsController < ApplicationController
  before_action :authenticate_user!

  def ready_for_pdf_conversion
    @publications = Publication.where("publication_status @> ?", '{7. ready for pdf conversion}')

    render json: @publications
  end
end
