class AddPublicationUrlToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :publication_url, :string, default: ""
  end
end
