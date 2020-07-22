class RemovePdfFileFromPublications < ActiveRecord::Migration[5.2]
  def change
    remove_column :publications, :pdf_file, :publications
  end
end
