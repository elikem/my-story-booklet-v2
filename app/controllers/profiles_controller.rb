class ProfilesController < ApplicationController
  def show
    # @profile = Profile.friendly.find(params[:id])
    # @user = Profile.find(@profile.id).user
    # # assumes a single story...find returns a single record
    # @story = Story.find(@user.stories)
    # @publication = Publication.where(story_id: story).order(:updated_at).last

    # if (@profile && @user && @publication)
    #     return publication
    # else
    #     raise ActiveRecord::RecordNotFound
    # end
    render plain: "user profile not found" unless @profile = Profile.friendly.find(params[:id])
    render plain: "user not found" unless @user = Profile.find(@profile.id).user
    render plain: "publication not found" unless @publication = Publication.where(story_id: @user.stories.first.id).order(:updated_at).last
  end

  def update
    @profile = Profile.find_by_username(params[:id])

    respond_to do |format|
      if @profile.update_attributes(profile_params)
        format.js
      else
        format.js
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:public_access)
  end
end
