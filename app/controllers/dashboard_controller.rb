class DashboardController < ApplicationController
  def show
    @user = current_user
    @stories = @user.stories
    @profile = @user.profile
  end
end
