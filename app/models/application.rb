class Application < ApplicationRecord
  has_many :applications
  has_many :pets, through: :pet_applications
  # include ActiveModel::Validations
  # enum :application_status, [ :draft, :published, :archived, :trashed ]

end
