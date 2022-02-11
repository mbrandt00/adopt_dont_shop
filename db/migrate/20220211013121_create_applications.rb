class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :description
      t.string :application_status
      t.string :desired_dogs, array: true, default: []

      t.timestamps
    end
  end
end
