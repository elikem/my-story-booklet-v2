class PublicationStatusAsAString < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :publication_status, :string, default: ""
  end
end
