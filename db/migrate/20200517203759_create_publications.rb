class CreatePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :publications do |t|
      t.string :publication_status
      t.belongs_to :story, foreign_key: true

      t.timestamps
    end
  end
end
