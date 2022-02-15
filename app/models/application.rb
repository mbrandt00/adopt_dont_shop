class Application < ApplicationRecord
  has_many :pet_applications, dependent: :delete_all
  has_many :pets, through: :pet_applications
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true, numericality: true
  validates :state, presence: true
  enum status: {"In Progress": 0, "Pending": 1, "Approved": 2, "Rejected": 3}
  before_save :normalize_name, on: :create
  def adopt(pet)
    self.pets << pet
  end

  def self.require_action(shelter_id)
    applications = Hash.new
    where(status: 1).joins(pet_applications: :pet).where(pets: {shelter_id: shelter_id}).each do |application|
      applications[application] = application.pets
    end
    return applications
  end
  private
    def normalize_name
      self.name = name.downcase.titleize
    end
end
