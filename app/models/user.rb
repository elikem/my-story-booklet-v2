# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  country_of_residence   :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  languages_spoken       :text             default([]), is an Array
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :lockable, :trackable

  validates :username, presence: true, uniqueness: true

  # new registration usernames should be lowercase
  before_create :username_should_be_lowercase
  # when a new user is created a Profile should be created as well
  after_create :create_users_public_profile
  # when the username on the User is updated, so is the Profile's username and slug (friendly_id)
  after_save :update_profile_friendly_id_with_username, if: :saved_change_to_username?

  has_many :stories
  has_one :profile

  def create_users_public_profile
    self.build_profile(username: self.username.downcase)
  end

  def update_profile_friendly_id_with_username
    self.profile.update(username: self.username.downcase)
  end

  def username_should_be_lowercase
    self.username = self.username.downcase
  end

  def public_profile_url
    "#{CONFIG["core_app_domain"]}/profiles/#{self.username}"
  end
end
