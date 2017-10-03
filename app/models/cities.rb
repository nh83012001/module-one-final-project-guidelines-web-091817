class City < ActiveRecord::Base
  # has_many :reviews

  def self.set_starting_city(city) # Raise error if not found
    city = City.find_by(name: city)
    @@coordinates = [city.latitude, city.longitude]
  end

  def self.populate_distances
    City.all.each do |destination|
      destination_coordinates = [destination.latitude, destination.longitude]
      distance = Distance.calculate(@@coordinates, destination_coordinates)
      destination.update(distance: distance)
    end
  end

  def self.coordinates
    @@coordinates
  end

  def self.list_cities(distance, minimum_population, maximum_population)
    cities = City.where("distance < ? and population > ? and population < ?", distance, minimum_population, maximum_population)
    cities.map {|city| city.name}
  end
end
