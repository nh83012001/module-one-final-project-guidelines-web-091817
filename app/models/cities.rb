class City < ActiveRecord::Base

  def self.set_starting_city(city) # Raise error if not found
    @@city = City.find_by(name: city)
    @@coordinates = [@@city.latitude, @@city.longitude] if @@city
  end

  def self.city
    @@city
  end

  def self.populate_distances(distance_parameter)
    cities_within_all_parameters = []
    @@cities.each do |destination|
      destination_coordinates = [destination.latitude, destination.longitude]
      distance = Distance.calculate(@@coordinates, destination_coordinates)
      cities_within_all_parameters << destination.name if distance < distance_parameter
    end
    @@query_count = cities_within_all_parameters.count
    cities_within_all_parameters
  end

  def self.coordinates
    @@coordinates
  end

  def self.list_cities_within_population(minimum_population, maximum_population)
    @@cities = City.where("population > ? and population < ? and name != ?", minimum_population, maximum_population, @@city.name)
  end

  def self.query_count
    @@query_count
  end
end
