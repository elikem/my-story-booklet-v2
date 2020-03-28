class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when "landing"
      "plain"
    else
      "application"
    end
  end
end
