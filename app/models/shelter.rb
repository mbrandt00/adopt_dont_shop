class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_alphabetical_descending
    find_by_sql('select * from shelters order by name desc;')
  end

  def self.order_by_number_of_pets
    select('shelters.*, count(pets.id) AS pets_count')
      .joins('LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id')
      .group('shelters.id')
      .order('pets_count DESC')
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.pending_applications
    pending_shelter_ids = Application.where(status: 'Pending').joins(:pets).pluck(:shelter_id).uniq
    find(pending_shelter_ids)
  end

  def average_adoptable_age
    pets.where(adoptable: true).average(:age).round(1)
  end

  def adoptable_pet_count
    pets.where(adoptable: true).count
  end

  def count_of_adopted_pets
    pets.where(adoptable: false).count
  end

  def undecided_pets
    pets.where(adoptable: true)
  end
end
