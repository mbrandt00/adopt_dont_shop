class PetApplication < ApplicationRecord
  enum status: {"Accepted": 0, "Rejected": 1}
  belongs_to :application
  belongs_to :pet

  def self.find_joins_row(application, pet)
      pet_id = pet.id
      app_id = application.id
      where(pet_id: pet_id, application_id: app_id)
    end

  def self.find_approved_pets(application)
     app_id = application.id
     ids = where(application_id: app_id, status: 0).pluck(:pet_id)
     Pet.find(ids)
  end

  def self.find_rejected_pets(application)
     app_id = application.id
     ids = where(application_id: app_id, status: 1).pluck(:pet_id)
     Pet.find(ids)
  end

  def self.find_undecided_pets(application)
     app_id = application.id
     ids = where(application_id: app_id, status: nil).pluck(:pet_id)
     Pet.find(ids)
   end
end
