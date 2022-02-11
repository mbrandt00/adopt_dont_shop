require 'rails_helper'

 RSpec.describe 'manufacturers index page' do

   let!(:steinway) {Manufacturer.create!(maker: "Steinway & Sons", location: "Manhattan, USA", year_opened: "1853", family_owned: true, ceo: "Ron Losby")}
   let!(:bechstein) {Manufacturer.create!(maker: "C. Bechstein", location: "Berlin, Germany", year_opened: "1853", family_owned: true, ceo: "Stefan Freymuth")}
   let!(:yamaha) {Manufacturer.create!(maker: "Yamaha", location: "Hamamatsu, Japan", year_opened: "1887", family_owned: false, ceo: "Yoshihiro Hidaka")}
   let!(:nord) {Manufacturer.create!(maker: "Nord", location: "Stockholm, Sweden", year_opened: "1983", family_owned: true, ceo: "Hans Nordelius")}
   let(:piano_1) {steinway.pianos.create!(model: "Model D", style: "Concert Grand", price: 150000, color: "black", acoustic: true)} #length: "8ft 11in")
   let(:piano_2) {steinway.pianos.create!(model: "Model B", style: "Concert Grand", price: 101700, color: "black", acoustic: true)} #length: "6ft 10in")
   let(:piano_3) {steinway.pianos.create!(model: "Model A", style: "Concert Grand", price: 85000, color: "black", acoustic: true)} #length: "6ft 2in")
   let(:piano_4) {steinway.pianos.create!(model: "Model O", style: "Concert Grand", price: 70000, color: "black", acoustic: true)} #length: "5ft 10in")

   it "can see all manufacturers by name" do

     visit "/manufacturers"
     expect(page).to have_content(steinway.maker)
     expect(page).to have_content(bechstein.maker)
     expect(page).to have_content(yamaha.maker)
     expect(page).to have_content(nord.maker)
   end


   it "can display records by most recent ordering" do
     # Manufacturer.create!(maker: "Steinway & Sons", location: "Manhattan, USA", year_opened: "1853", family_owned: true, ceo: "Ron Losby")
     michael_brandt = Manufacturer.create!(maker: "Cool Piano", location: "Denver, CO", year_opened: "2000", family_owned: true, ceo: "Michael Brandt")
     visit "/manufacturers"
     # save_and_open_page
     expect(current_path).to eq('/manufacturers')
     expect(michael_brandt.location).to appear_before(steinway.location)
   end

   it "can display a link to create a new manufacturer" do # User story 11
     visit '/manufacturers'
     save_and_open_page
     click_link 'New Manufacturer'
     fill_in 'maker', with: "Dani Coleman"
     fill_in 'location', with: "Colorado, USA"
     fill_in 'year_opened', with: 1980
     # fill_in 'family_owned', with: "Dani Coleman"
     fill_in 'ceo', with: "Dani Coleman"
     click_button 'Create Manufacturer'
     expect(current_path).to eq('/manufacturers')
     expect(page).to have_content('Dani Coleman')
   end




 end
