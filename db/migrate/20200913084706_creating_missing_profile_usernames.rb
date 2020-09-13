class CreatingMissingProfileUsernames < ActiveRecord::Migration[5.2]
  User.find_each do |u|
    if u.profile.present?
    else
      Profile.create!(user_id: u.id) unless u.profile.present?
    end
  end
end
