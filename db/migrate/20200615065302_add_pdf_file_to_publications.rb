class AddPdfFileToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :pdf_file, :binary
  end
end
