module DashboardHelper
  def show_user_story
    if current_user.stories.empty?
      "no stories"
    else
      "show my story"
    end
  end
end
