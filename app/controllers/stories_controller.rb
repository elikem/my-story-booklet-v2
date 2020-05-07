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
      flash[:success] = "Your story was saved"
      redirect_to "/"
    else
      flash.now[:error] = "You story was not saved"
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
      render "publish", locals: {story: @story}
    end

    # publication_status => # publication, step-1-create-user-folder, step-2-add-IDML-template-folder,
    # step-3-modify-IDML-files-with-user-entry, step-4-generate-IDML-file, step-5-upload-IDML-to-S3, step-6-check-S3-for-PDF,
    # step-7-email-user
    #
    # create user folder with IDML files
    # output xml files w/ format email-address_version-number_filename.xml
    # replace xml files
    # generate IDML file w/ format user-id_version-number_mystorybooklet.idml
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
