class CreateMissingUserProfiles < ActiveRecord::Migration[5.2]
  def change
    User.find_each do |u|
      username = "#{u.first_name}-#{u.last_name}-#{SecureRandom.random_number(10..99)}".downcase
      Profile.create!(username: "", user_id: u.id) unless u.profile.present? 
    end
  end
end

