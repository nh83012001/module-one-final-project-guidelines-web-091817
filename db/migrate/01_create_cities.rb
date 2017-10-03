class CreateCities < ActiveRecord::Migration[5.1]
  # Populates with the city_state CSV data
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :population
      t.float :latitude
      t.float :longitude
      t.integer :zip_code
      t.float :distance
    end
  end
end
