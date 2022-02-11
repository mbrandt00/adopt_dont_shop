class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates :pet, presence: true
  validates :application, presence: true
  enum application_status: [ 'In progress', 'Complete' ]

end
