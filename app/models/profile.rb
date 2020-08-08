# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  slug       :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_profiles_on_slug     (slug) UNIQUE
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
    extend FriendlyId
    friendly_id :username, use: :slugged

    belongs_to :user 

    private

    def find_publication
        binding.pry
    end
end
