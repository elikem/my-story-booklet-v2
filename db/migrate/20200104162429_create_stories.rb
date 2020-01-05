class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :language
      t.text :content
      t.string :status
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
