class DashboardController < ApplicationController
  def show
    @user = current_user
    @stories = @user.stories
  end
end
