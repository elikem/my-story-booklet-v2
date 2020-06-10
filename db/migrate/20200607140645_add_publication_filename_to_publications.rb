class AddPublicationFilenameToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :publication_filename, :string, default: ""
  end
end
