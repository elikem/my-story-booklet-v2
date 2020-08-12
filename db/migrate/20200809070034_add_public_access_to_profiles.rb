class AddPublicAccessToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :public_access, :boolean, default: false
  end
end
