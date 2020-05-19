class PublicationNumberFromBigintToString < ActiveRecord::Migration[5.2]
  def change
    change_column :publications, :publication_number, :string
  end
end
