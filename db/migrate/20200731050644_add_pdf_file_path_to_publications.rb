class AddPdfFilePathToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :pdf_file_path, :string
  end
end
