require 'rails_helper'

RSpec.describe 'application show page' do
  it 'will have errors if required fields are missing' do
    visit "/pets"
    click_link "Start an Application"
    expect(current_path).to eq("/pets/applications/new")
    fill_in "street_address", with: '100 Main Street'
    fill_in "city", with: 'Portland'
    fill_in "state", with: 'Oregon'
    fill_in "zipcode", with: 97035
    click_button "Submit Application"
    expect(current_path). to eq("/pets/applications")
    expect(page).to have_content('Missing Input')
  end
  describe 'adding pets to application' do
    before(:each) do
      @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
      @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
      visit "/pets"
      click_link "Start an Application"
      expect(current_path).to eq("/pets/applications/new")
      fill_in "name", with: 'Bob Smith'
      fill_in "street_address", with: '100 Main Street'
      fill_in "city", with: 'Portland'
      fill_in "state", with: 'Oregon'
      fill_in "zipcode", with: 97035
      click_button "Submit Application"
      expect(page).to_not have_content("Submit Application")
    end
    it 'will have a space to add a pet to the application' do
      expect(page).to have_content("Please add a pet to this application")
      within "#pet-#{@pet_1.id}" do
        expect(page).to have_button("Select #{@pet_1.name}")
        click_button("Select #{@pet_1.name}")
      end
      within ".selected_dogs" do
        expect(page).to have_content("Name: #{@pet_1.name}")
      end
    end
    it 'will be able to sort pets by name' do
      within ".dog_search" do
        fill_in "search", with: 'Lobster'
        click_on "Search"
      end
      within ".filtered_dogs" do
        expect(page).to have_content(@pet_2.name)
        expect(page).to_not have_content(@pet_1.name)
      end
    end
    describe 'searching' do
      it 'will be able to search for partial names' do
        within ".dog_search" do
          fill_in "search", with: 'Lob'
          click_on "Search"
        end
        within ".filtered_dogs" do
          expect(page).to have_content(@pet_2.name)
          expect(page).to_not have_content(@pet_1.name)
        end
      end
      it 'will be a case insensitive search' do
        within ".dog_search" do
          fill_in "search", with: 'lob'
          click_on "Search"
        end
        within ".filtered_dogs" do
          expect(page).to have_content(@pet_2.name)
          expect(page).to_not have_content(@pet_1.name)
        end
      end
    end
    describe 'Submitting an application' do
      it 'will require pets' do
        within ".filtered_dogs" do
          click_on "Select #{@pet_1.name}"
        end

        expect(page).to have_content("To finish submitting your application, please answer the question below and submit.")
      end
      it 'can submit when a description is added' do
        within ".filtered_dogs" do
          click_on "Select #{@pet_1.name}"
        end
        within ".more_dogs" do
          click_on "Select #{@pet_2.name}"
        end
        within(".submission") do
          expect(page).to have_content("Please describe why you would be a good owner.")
          fill_in "description", with: "Im a good person!"
          expect(page).to have_button "Submit Application"
          click_button "Submit Application"
        end
        expect(page).to have_content("Pending")
      end
    end
  end
end
