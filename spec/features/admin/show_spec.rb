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
  describe 'as a visitor' do
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
    end
    it 'will show the number of adoptable pets in one shelter' do
      @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: false)
      visit "/admin/shelters/#{@shelter_1.id}"
      within ".shelter_statistics" do
        expect(page).to have_content('2 Pets')
      end
    end
  end
end

# As a visitor
# When I visit an admin shelter show page
# Then I see a section for statistics
# And in that section I see the number of pets at that shelter that are adoptable
