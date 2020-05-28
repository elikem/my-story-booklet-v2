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
    # create a publication for user story, the publication auto-generates the publication number (which should be unique)
    @publication = Publication.create!(story_id: @story.id)

    render "publish", locals: { story: @story, publication: @publication }
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
