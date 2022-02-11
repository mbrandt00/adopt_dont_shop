class Application < ApplicationRecord
  has_many :applications
  has_many :pets, through: :pet_applications
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  validates :description, presence: true
  # enum :application_status, [ :draft, :published, :archived, :trashed ]

end
