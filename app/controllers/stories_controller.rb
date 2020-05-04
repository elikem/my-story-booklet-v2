class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_current_user_as_submitter, only: [:create, :update]

  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.js
      else
        format.js
      end
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])

    if @story.update_attributes(story_params)
      redirect_to "/", success: "Your story was saved"
    else
      render "edit"
    end
  end

  def destroy
    Story.find(params[:id]).destroy
    redirect_to controller: "dashboard", action: "show"
  end

  def publish
    @story = Story.find(params[:id])

    if @story.update_attribute(:version_number, @story.version_number.to_i + 1)
      render "publish"
    else
      render "publish"
    end

    # create user folder with IDML files
    # output xml files w/ format email-address_version-number_filename.xml
    # replace xml files
    # generate IDML file w/ format email-address_version-number_mystorybooklet.idml
    # upload to S3
  end

  private

  def story_params
    params.require(:story).permit(:content, :language, :status, :user_id, :title, :version_number)
  end

  # Ensures that the user story being saved belongs to the authenticated user. If not, redirect to new_story_path.
  def validate_current_user_as_submitter
    if current_user.id.to_s != story_params[:user_id]
      redirect_to new_story_path
    end
  end
end
