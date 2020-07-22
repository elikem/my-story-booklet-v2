class AddPdfUrlToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :pdf_url, :string
  end
end
