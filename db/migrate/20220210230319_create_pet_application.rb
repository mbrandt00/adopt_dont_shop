class CreatePetApplication < ActiveRecord::Migration[5.2]
  def change
    create_table :pet_applications do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :application_status
      t.timestamps
    end
  end
end
