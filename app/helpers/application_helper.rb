module ApplicationHelper
  def display_users_full_name
    if current_user.first_name.present? || current_user.last_name.present?
      current_user.first_name + " " + current_user.last_name
    else
      ""
    end
  end

  # show user links in top navigation based on user sign state
  def display_top_navigation_user_links
    if user_signed_in?
      render(partial: "shared/top-navigation/user_signed_in_links")
    else
      render(partial: "shared/top-navigation/user_not_signed_in_links")
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
