# == Schema Information
#
# Table name: profiles
#
#  id            :bigint           not null, primary key
#  public_access :boolean          default(FALSE)
#  slug          :string
#  username      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Foreign Keys
#
#  profiles_user_id_fkey  (user_id => users.id)
#
class Profile < ApplicationRecord
  # everytime the username is updated, so is the slug
  after_save :update_profile_friendly_id_with_username, if: :saved_change_to_username?

  extend FriendlyId
  friendly_id :username, use: :slugged

  belongs_to :user

  private

  def update_profile_friendly_id_with_username
    self.update(slug: self.username.downcase)
  end
end
