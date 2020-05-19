class RemoveDefaultFromPublicationNumber < ActiveRecord::Migration[5.2]
  def change
    change_column_null :publications, :publication_number, true
    change_column_default :publications, :publication_number, nil
  end
end
