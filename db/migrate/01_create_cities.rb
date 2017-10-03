require 'pry'

class CreateCity < ActiveRecord::Migration #gets you access to database
  def change
    create_table :cities do |t|
      t.string :city
      t.string :state
      t.integer :population
      t.float :longitude
      t.float :latitude
      t.float :distance
    end
  end
end
