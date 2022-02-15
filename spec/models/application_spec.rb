require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'assocations' do
    it { have_many :applications}
    it { have_many :pet_applications}
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zipcode) }
    it { should validate_numericality_of(:zipcode) }
    it { should validate_presence_of(:state) }
  end
  describe 'callbacks' do
    it 'will normalize and titelize the name' do
      application = Application.create(name: 'bobby fisher', street_address: '100 east st', city: 'la', state: 'CA', zipcode: 1234)
      expect(application.name).to eq('Bobby Fisher')
    end
  end
  describe 'class methods' do
    it 'will add pets to an application' do
      application = Application.create(name: 'bobby fisher', street_address: '100 east st', city: 'la', state: 'CA', zipcode: 1234)
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
      application.adopt(pet_1)
      application.adopt(pet_2)
      expect(application.pets).to eq([pet_1, pet_2])
    end
    it 'will add pets to an application' do
      application = Application.create(name: 'bobby fisher', street_address: '100 east st', city: 'la', state: 'CA', zipcode: 1234, status: 'Pending')
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
      application.adopt(pet_1)
      application.adopt(pet_2)
      expect(Application.require_action(shelter_1)).to eq({application => [pet_1, pet_2]})
    end
  end
end
