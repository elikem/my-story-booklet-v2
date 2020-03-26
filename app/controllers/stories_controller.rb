class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_current_user_as_submitter, only: [:create, :update]

  def index
    redirect_to new_story_path
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    puts "===================="
    puts @story.errors.messages

    respond_to do |format|
      if @story.save
        format.html { redirect_to action: "show", id: @story.id }
        format.js
      else
        format.html { render "new" }
        format.js
      end
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(story_params)
        format.html { redirect_to controller: "dashboard", action: "show" }
        format.js
      else
        format.html { render action: "edit" }
        format.js
        @story.errors.full_message
      end
    end
  end

  def delete
    Story.find(params[:id]).destroy
    redirect_to action: "index"
  end

  private

  def story_params
    params.require(:story).permit(:content, :language, :status, :user_id)
  end

  # Ensures that the user story being saved belongs to the authenticated user. If not, redirect to new_story_path.
  def validate_current_user_as_submitter
    if current_user.id.to_s != story_params[:user_id]
      redirect_to new_story_path
    end
  end
end
