module DashboardHelper
  def display_or_create_story(user)
    if story_count_for(user) > 0
      render(partial: "dashboard/story/user_with_story")
    else
      # TODO: Create user story and display in partial
      render(partial: "dashboard/story/user_without_story")
    end
  end
end
