class CreateMissingUserUsernames < ActiveRecord::Migration[5.2]
  User.find_each do |u|
    username = "#{u.first_name}-#{u.last_name}-#{SecureRandom.random_number(10..99)}".downcase

    u.update(username: username) unless u.username.present?
  end
end
