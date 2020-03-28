module StoriesHelper
  # show number of stories for a given user
  def story_count_for(user)
    User.find_by_id(user).stories.count
  end

  def list_story_ids_for(user)
    User.find_by_id(user).stories.map{ |story| story.id }
  end
end