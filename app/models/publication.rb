class Publication < ApplicationRecord
  before_create :set_publication_number

  belongs_to :story

  def set_publication_number
    self.publication_number = SecureRandom.urlsafe_base64
  end
end
