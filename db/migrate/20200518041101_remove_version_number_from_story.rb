class RemoveVersionNumberFromStory < ActiveRecord::Migration[5.2]
  def change
    remove_column :stories, :version_number
  end
end
