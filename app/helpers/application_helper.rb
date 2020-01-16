module ApplicationHelper
  def display_users_full_name
    if current_user.first_name.present? || current_user.last_name.present?
      current_user.first_name + " " + current_user.last_name
    else
      ""
    end
  end

  def user_stories?(user_id)
    User.find_by_id(user_id).stories.count > 0 ? true : false
  end
end
