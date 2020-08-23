class DashboardController < ApplicationController
  def show
    @user = current_user
    @stories = @user.stories
    @profile = @user.profile
    @publication = Publication.get_latest_publication_with_pdf(@profile.username)
  end
end
