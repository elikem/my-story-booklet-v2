class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when "landing"
      "plain"
    when "test"
      "plain"
    when "sign-in"
      "plain"
    else
      "application"
    end
  end
end
