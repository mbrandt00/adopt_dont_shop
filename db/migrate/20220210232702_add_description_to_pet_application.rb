class AddDescriptionToPetApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :pet_applications, :description, :string
  end
end
