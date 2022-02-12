class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  enum status: {"In Progress": 0, "Pending": 1, "Accepted": 2, "Rejected": 3}

  def adopt(pet)
    self.pets << pet
  end

end
