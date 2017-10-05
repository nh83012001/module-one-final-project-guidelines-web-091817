require 'pry'

class Rating < ActiveRecord::Base
  def self.list_city_ratings(city)
    id = City.find_by(name: city).id
    city_ratings = Rating.where("city_id = ?", id).sort_by {|city| city[:avg_rating]}.reverse
    city_ratings.each_with_index do |data, index|
      puts " \n#{index + 1}. #{data[:term].titleize}"
      puts "Average Rating: #{data[:avg_rating]}"
      puts "Sum of Reviews: #{data[:sum_of_reviews]}\n "
      sleep(2)
    end
  end
end
