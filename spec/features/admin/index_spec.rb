require 'rails_helper'

RSpec.describe 'Admin index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
  end
  describe 'as a visitor' do
    it 'will show all shelters in reverse alphabetical order on admin/shelters' do
      visit 'admin/shelters'
      within '.Shelters' do
        expect(@shelter_2.name).to appear_before(@shelter_1.name)
      end
    end
    it 'will show all shelters that have a pending application' do
      visit "/pets"
      click_link "Start an Application"
      expect(current_path).to eq("/pets/applications/new")
      fill_in "name", with: "Roger Stone"
      fill_in "street_address", with: '100 Main Street'
      fill_in "city", with: 'Portland'
      fill_in "state", with: 'Oregon'
      fill_in "zipcode", with: 97035
      click_button "Submit Application"
      within ".filtered_dogs" do
        click_on "Select #{@shelter_1.pets.first.name}"
      end
      within(".submission") do
        fill_in "description", with: "Im a good person!"
        click_button "Submit Application"
      end
      expect(page).to have_content("Pending")
      visit "/admin/shelters"
      expect(page).to have_content(@shelter_1.name)
    end
  end
end
