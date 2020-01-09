module DashboardHelper
  def show_dashboard_story_content
    if user_stories?(current_user.id)
      render 'dashboard/user_with_story'
    else
      render 'dashboard/user_without_story'
    end
  end
end
