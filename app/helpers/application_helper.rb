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

  # the top navigation uses this to determine whether to show links for a logged in user or for an unauthenticated
  # user.
  def show_link_to_sign_in_page_or_logged_in_user_links
    if user_signed_in?
      render(partial: "shared/top-navigation/logged_in_user_links")
    else
      render(partial: "shared/top-navigation/link_to_sign_in_page")
    end
  end

  # https://coderwall.com/p/jzofog/ruby-on-rails-flash-messages-with-bootstrap
  # provides bootstrap classes to flash messages
  def flash_class(level)
    # level might come in as a string or symbol
    level = level.to_sym

    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :alert then "alert alert-danger"
      when :error then "alert alert-danger"
    end
  end
end
