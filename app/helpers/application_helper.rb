module ApplicationHelper
  def display_users_full_name
    "Jessica Jones"
  end

  def user_stories?(user_id)
    User.find_by_id(user_id).stories.count > 0 ? true : false
  end
end
