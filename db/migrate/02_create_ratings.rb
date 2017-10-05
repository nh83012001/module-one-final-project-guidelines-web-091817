class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :city_id
      t.string :term
      t.float :avg_rating
      t.integer :sum_of_reviews
    end
  end
end
