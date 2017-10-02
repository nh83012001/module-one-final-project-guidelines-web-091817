require 'csv'
require 'pry'


populations = CSV.read('/coordinates.csv', :encoding => 'windows-1251:utf-8')
binding.pry
population_array = []

populations.each do |line|
  population_array << {city: line[0], state: line[1], postal_code: line[2], latitude: line[3], longitude: line[4]}
end
