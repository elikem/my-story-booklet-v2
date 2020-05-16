module StoriesHelper
  # show number of stories for a given user
  def story_count_for(user)
    User.find_by_id(user).stories.count
  end

  def list_story_ids_for(user)
    User.find_by_id(user).stories.map { |story| story.id }
  end

  def display_story_link_for(user)
    # since there's only one story we can just get the first story
    # story => we're checking for an authenticated user and existing story before trying to retrieve their stories
    # story_link => checking for a valid story before generating an edit story path
    # link_disability_state => checking for a valid story before setting the link's disability state

    if user_signed_in? && User.find_by_id(current_user).stories
      story = User.find_by_id(current_user).stories.first
    else
      story = false
    end

    story_link = story ? edit_story_path(story) : "javascript:void(0)"
    link_disability_state = story ? "" : "disabled"

    render(partial: "shared/layout/navigation/link_for_stories", locals: { story: story, story_link: story_link, link_disability_state: link_disability_state })
  end

  def display_story_title(story_id)
    unless Story.find_by_id(story_id).title.nil?
      raw Story.find_by_id(story_id).title
    end
  end
end
