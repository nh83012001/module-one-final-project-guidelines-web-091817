require 'csv'
require 'pry'

# Populates the Cities table with the CSV data

# Reads CSV data
city_data = CSV.read('./lib/resources/csvs/city_data.csv', col_sep: "$", encoding: "ISO8859-1")

city_data.each do |line|
  line = line.first.split(",")
  City.create(
  name: line[2],
  population: line[3],
  latitude: line[4],
  longitude: line[5],
  zip_code: line[6],
  distance: 0
  )
end
