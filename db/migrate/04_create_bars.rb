class CreateBar< ActiveRecord::Migration #gets you access to database
  def change
    create_table :bars do |t|
      t.string :name
      t.string :rating
      t.integer :state_id
      t.integer :city_id 
    end
  end
end
