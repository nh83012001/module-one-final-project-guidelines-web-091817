require 'csv'
require 'pry'
# require 'geocoder'
# require 'geokit'

DEFAULT_COORDINATES = [40.7052799,-74.0162189]

coordinates = CSV.read('/Users/nicholaspaolino/Desktop/Flatiron School/Project/module-one-final-project-guidelines-web-091817/lib/csvs/populations.csv', col_sep: "$", encoding: "ISO8859-1")
populations = CSV.read('/Users/nicholaspaolino/Desktop/Flatiron School/Project/module-one-final-project-guidelines-web-091817/lib/csvs/coordinates.csv', encoding: 'windows-1251:utf-8')

populations = populations[1...populations.count]

populations_array, coordinates_hash = [], {}

coordinates.each do |line|
  line = line.first.split(",")
  city_state = line[4]
  coordinates_hash[city_state] = [line[1], line[2]]
end

def distance(loc1, loc2)
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end

not_found_counter = 0
not_found_population_greater = 0

populations.each do |line|
  city_state = line[2]
  population = line[3]
  if coordinates_hash[city_state]
    coordinates = coordinates_hash[city_state].map {|s| s.to_f}
    distance_in_meters = distance(DEFAULT_COORDINATES, coordinates)
    distance_in_miles = (distance_in_meters / 1609.34).round(2)
    populations_array << {city_state => {
      population: population,
      distance_from: distance_in_miles,
      coordinates: coordinates
      }}
  else
    not_found_counter += 1
    not_found_population_greater += 1 if population.to_i > 500000
  end
end

puts populations_array
puts not_found_counter
puts not_found_population_greater
