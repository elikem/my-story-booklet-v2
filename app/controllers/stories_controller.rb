class StoriesController < ApplicationController
  def index
    @stories = Story.all
    @story = Story.new
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html {
          redirect_to action: "show", id: @story.id
          flash[:success] = "Your story was saved."
        }

        format.js {}
      else
        puts @story.errors.full_messages

        format.html {
          redirect_to action: "new"
          flash[:alert] = "Your story was not saved."
        }

        format.js {}
      end
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])

    if @story.update_attributes(story_params)
      redirect_to action: "show", id: @story
    else
      render action: "edit"
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
end
