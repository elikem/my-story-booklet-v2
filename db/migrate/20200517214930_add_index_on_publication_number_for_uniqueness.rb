class AddIndexOnPublicationNumberForUniqueness < ActiveRecord::Migration[5.2]
  add_index :publications, :publication_number, unique: true
end
