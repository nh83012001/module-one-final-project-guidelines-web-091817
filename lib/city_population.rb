require 'csv'
require 'pry'


populations = CSV.read('population.csv', :encoding => 'windows-1251:utf-8')
binding.pry
population_array = []

populations.each do |line|
  population_array << {city: line[0], state: line[1], population: line[2]}
end
