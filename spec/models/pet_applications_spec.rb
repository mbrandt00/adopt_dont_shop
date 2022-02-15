require 'rails_helper'

RSpec.describe PetApplication do
  context 'associations' do
    it {should belong_to(:application)}
    it {should belong_to(:pet)}
  end
  describe 'class methods' do
    before(:each) do
      @application = Application.create(name: 'bobby fisher', street_address: '100 east st', city: 'la', state: 'CA', zipcode: 1234, status: 'Pending')
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
      @application.adopt(@pet_1)
      @application.adopt(@pet_2)
    end
    it '.find_joins_row' do
      expect(PetApplication.find_joins_row(@application, @pet_1).first.application_id).to eq(@application.id)
      expect(PetApplication.find_joins_row(@application, @pet_1).first.pet_id).to eq(@pet_1.id)
    end
    it '.find_approved_pets' do
      pet_application_1 = PetApplication.find_joins_row(@application, @pet_1).first
      pet_application_2 = PetApplication.find_joins_row(@application, @pet_2).first
      pet_application_1.Accepted!
      pet_application_2.Rejected!
      expect(PetApplication.find_approved_pets(@application)).to eq([@pet_1])
    end
    it '.find_rejected_pets' do
      pet_application_1 = PetApplication.find_joins_row(@application, @pet_1).first
      pet_application_2 = PetApplication.find_joins_row(@application, @pet_2).first
      pet_application_1.Accepted!
      pet_application_2.Rejected!
      expect(PetApplication.find_rejected_pets(@application)).to eq([@pet_2])
    end
    it '.find_undecided_pets' do
      pet_application_1 = PetApplication.find_joins_row(@application, @pet_1).first
      pet_application_2 = PetApplication.find_joins_row(@application, @pet_2).first
      pet_application_1.Accepted!
      expect(PetApplication.find_undecided_pets(@application)).to eq([@pet_2])
    end
  end
end
