class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :country_of_residence, :string
    add_column :users, :languages_spoken, :text, array: true, default: []
  end
end
