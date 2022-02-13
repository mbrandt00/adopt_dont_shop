class Pet < ApplicationRecord
  has_many :pet_applications, dependent: :delete_all
  has_many :applications, through: :pet_applications
  belongs_to :shelter

  validates :name, presence: true
  validates :age, presence: true, numericality: true
  validates :breed, presence:true

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.sorted(dogname)
    where("lower(name) LIKE ?", "%#{dogname.downcase}%")
  end


end
