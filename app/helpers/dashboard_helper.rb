module DashboardHelper
  def list_or_create_story
    if story_count_for(current_user.id) > 0
      render(partial: "dashboard/story/user_with_story")
    else
      render(partial: "dashboard/story/user_without_story")
    end
  end
end
