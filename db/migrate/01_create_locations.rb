class CreateCity < ActiveRecord::Migration #gets you access to database
  def change
    create_table :cities do |t|
      t.string :city
      t.string :state
      t.integer :population
      t.integer :distance 
    end
  end
end
