class Story < ApplicationRecord
  belongs_to :user

  validates :content, length: { maximum: 3000 }
end
