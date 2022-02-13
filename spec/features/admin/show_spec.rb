
require 'rails_helper'

RSpec.describe 'Admin show page' do
  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
    @pet_3 = Pet.create(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: @shelter_2.id)
    @pet_4 = Pet.create(adoptable: true, age: 1, breed: 'orange tabby shorthair', name: 'Lasagna', shelter_id: @shelter.id)
    @application_1 = Application.create(name: "Art Schinner", street_address: "4873 Zboncak Mission", city: "Kuhlmanview", state: "Massachusetts", zipcode: 899, description: "I like pets!", status: "Pending")
    @application_2 = Application.create(name: "The Hon. Dion Hansen", street_address: "27332 Toya Route", city: "West Gale", state: "South Dakota", zipcode: 2863, description: "I like pets!", status: "Pending")
  end
  describe 'Approving an application' do
    it 'will have a button to approve the application for a specific pet' do
      @application_1.adopt(@pet_1)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button('Approve pet')
        expect(page).to have_content("Pet Approved")
      end
    end
    it 'will return to admin show page and have no button' do
      @application_1.adopt(@pet_1)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button('Approve pet')
        expect(page).to_not have_button("Approve pet")
      end
    end
  end
end
