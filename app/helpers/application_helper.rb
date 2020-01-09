module ApplicationHelper
  def display_full_name
    "Jessica Jones"
  end

  def show_user_story
    if current_user.stories.empty?
      "no stories"
    else
      "show my story"
    end
  end

  def user_has_stories?(user_id)
  end

  def user_has_a_story_in_english?(user_id)
  end
end
