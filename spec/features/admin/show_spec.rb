require 'rails_helper'

RSpec.describe 'Admin show page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
  end
  it 'will have links on the shelter name to take to shelters admin show page' do
    visit 'admin/shelters'
    within ".Shelters" do
      click_link "#{@shelter_1.name}"
    end
    expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")
  end
  describe 'statistics' do
    it 'will show the average age of all adoptable pets in the shelter' do
      visit "/admin/shelters/#{@shelter_1.id}"
      within ".shelter_statistics" do
        expect(page).to have_content('4.0 years old')
      end
    end
    it 'will show the number of adoptable pets in one shelter' do
      @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: false)
      visit "/admin/shelters/#{@shelter_1.id}"
      within ".shelter_statistics" do
        expect(page).to have_content('2 Pets')
      end
    end
    it 'will have a count of adopted pets from a shelter' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 3, breed: 'lynx', name: 'Larry', shelter_id: shelter.id)
      application_1 = Application.create(name: "Art Schinner", street_address: "4873 Zboncak Mission", city: "Kuhlmanview", state: "Massachusetts", zipcode: 899, description: "I like pets!", status: "Pending")
      application_2 = Application.create(name: "The Hon. Dion Hansen", street_address: "27332 Toya Route", city: "West Gale", state: "South Dakota", zipcode: 2863, description: "I like pets!", status: "Pending")
      application_1.adopt(pet_1)
      application_2.adopt(pet_2)
      visit "/admin/applications/#{application_1.id}"
      within "#selected_dog-#{pet_1.id}" do
        click_button('Approve Pet')
      end
      visit "/admin/applications/#{application_2.id}"
      within "#selected_dog-#{pet_2.id}" do
        click_button('Approve Pet')
      end
      visit "/admin/shelters/#{shelter.id}"
      expect(page).to have_content("Number of Adopted Pets: 2 Pets")
    end
  end
  describe 'Action Required' do
    before(:each) do
      @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter.id)
      @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      @pet_3 = Pet.create(adoptable: true, age: 3, breed: 'lynx', name: 'Larry', shelter_id: @shelter.id)
      @application_1 = Application.create(name: "Art Schinner", street_address: "4873 Zboncak Mission", city: "Kuhlmanview", state: "Massachusetts", zipcode: 899, description: "I like pets!", status: "Pending")
      @application_2 = Application.create(name: "The Hon. Dion Hansen", street_address: "27332 Toya Route", city: "West Gale", state: "South Dakota", zipcode: 2863, description: "I like pets!", status: "Pending")
      @application_1.adopt(@pet_1)
      @application_2.adopt(@pet_2)
    end
    it 'will show a list of all pets for this shleter that have a pending application' do
      visit "/admin/applications/#{@application_1.id}"
      visit "/admin/shelters/#{@shelter.id}"
      within ".action_required" do
        expect(page).to have_content("Bare-y Manilow")
        expect(page).to have_content("Lobster")
      end
    end
    it 'will have links in action_required to the applications show page' do
      visit "/admin/applications/#{@application_1.id}"
      visit "/admin/shelters/#{@shelter.id}"
      within "#pet-#{@pet_1.id}" do
        click_link("#{@pet_1.name}")
      end
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      within ".undecided_pets" do
        expect(page).to have_button("Reject Pet")
        expect(page).to have_button("Approve Pet")
      end
    end
  end
end
