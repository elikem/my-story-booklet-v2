class AddConversionStatusToPublication < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :conversion_status, :string, default: "pending"
  end
end
