class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :description
      t.integer :status, :integer, default: 0
      t.references :pets, foreign_key: true
    end
  end
end
