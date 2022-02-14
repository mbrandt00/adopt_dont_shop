
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
        click_button('Approve Pet')
      end
      within ".approved_pets" do
        expect(page).to have_content(@pet_1.name)
      end
    end
    it 'will return to admin show page and have no button' do
      @application_1.adopt(@pet_1)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button('Approve Pet')
      end
      expect(page).to_not have_button("Approve Pet")
    end
    it 'will change the adoptable status of a pet to false' do
      @application_1.adopt(@pet_1)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button('Approve Pet')
      end
      visit "/pets/#{@pet_1.id}"
      expect(page). to have_content("Adoptable? false")
    end
  end
  describe 'Rejecting a pet application' do
    it 'will have a button to reject a pet application' do
      @application_2.adopt(@pet_2)
      visit "/admin/applications/#{@application_2.id}"
      within "#selected_dog-#{@pet_2.id}" do
        expect(page).to have_button("Reject Pet")
        expect(page).to have_button("Approve Pet")
        click_button('Reject Pet')
      end
      within ".denied_pets" do
        expect(page).to have_content(@pet_2.name)
      end
    end
    it 'will will return to admin show page and have no button and say Rejected' do
      @application_1.adopt(@pet_1)
      visit "/admin/applications/#{@application_1.id}"
      within ".undecided_pets" do
        expect(page).to have_button("Reject Pet")
        expect(page).to have_button("Approve Pet")
        click_button('Reject Pet')
      end
      expect(page).to_not have_button('Reject Pet')
      expect(page).to_not have_button('Approve Pet')
    end
  end
  it 'accepting a pet on one application will not affect other applications with the same pet' do
    @application_1.adopt(@pet_1)
    @application_2.adopt(@pet_1)
    visit "/admin/applications/#{@application_1.id}"
    within ".undecided_pets" do
      click_button('Approve Pet')
    end
    within ".approved_pets" do
      expect(page).to have_content(@pet_1.name)
    end
    visit "/admin/applications/#{@application_2.id}"
      within ".undecided_pets" do
        expect(page).to have_button("Reject Pet")
        expect(page).to have_button("Approve Pet")
        click_button('Approve Pet')
      end
      within ".approved_pets" do
        expect(page).to have_content(@pet_1.name)
      end
    end
  describe 'Application status' do
    it 'will mark the application as rejected if even one pet is rejected' do
      @application_1.adopt(@pet_1)
      @application_1.adopt(@pet_2)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button("Approve Pet")
      end
      within "#selected_dog-#{@pet_2.id}" do
        click_button("Reject Pet")
      end
      expect(page).to have_content("Status: Rejected")
    end
    it 'will mark the application as accepted if all of the pets are accepted' do
      @application_1.adopt(@pet_1)
      @application_1.adopt(@pet_2)
      visit "/admin/applications/#{@application_1.id}"
      within "#selected_dog-#{@pet_1.id}" do
        click_button("Approve Pet")
      end
      within "#selected_dog-#{@pet_2.id}" do
        click_button("Approve Pet")
      end
      expect(page).to have_content("Status: Approved")
    end
  end
end
