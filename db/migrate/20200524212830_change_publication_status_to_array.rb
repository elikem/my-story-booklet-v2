class ChangePublicationStatusToArray < ActiveRecord::Migration[5.2]
  def change
    remove_column :publications, :publication_status
    add_column :publications, :publication_status, :text, array: true, default: []
  end
end