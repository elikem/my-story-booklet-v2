class PublicationStatusToString < ActiveRecord::Migration[5.2]
  def change
    remove_column :publications, :publication_status
  end
end
