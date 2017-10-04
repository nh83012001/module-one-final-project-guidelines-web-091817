require 'pry'

class CLI
  attr_accessor :city_array, :term, :city, :city_index_hash, :distance, :maximum_population, :minimum_population

  def initialize
    @city_index_hash = {}
    get_user_input
    list_cities_within_population
    @city_array = populate_distances
    approve_query_length
  end

  def list_cities_within_population
    City.list_cities_within_population(@minimum_population, @maximum_population)
  end

  def approve_query_length
    puts "There are #{City.query_count} cities that are within #{distance} miles of #{city} that are between #{minimum_population} and #{maximum_population} people."
    puts "Would you like to proceed with the search? Type 'Y' or 'N'."
    user_response = gets.chomp
      if user_response == "Y"
        execute_yelp_search
      elsif user_response == "N"
        CLI.welcome
      else
        user_response = gets.chomp
      end
  end

  def limit_query
    # if "N", how many would you like to limit it to? 50 cities
    #   Would you like to have the 10 biggest, smallest, closest, or furthest
    #   Would you lik
  end

  def execute_yelp_search
    mass_yelp_search
  end

  def get_user_input
    get_city
    get_term
    get_population
    get_distance_radius
  end

  def self.welcome
    puts "Hi and Welcome to CityYelp.\n"
    CLI.new
  end

  def add_array(city_array)
    @city_array = city_array
  end

  def get_term
    puts "Give a term to search: "
    @term = gets.chomp
  end

  def get_population
    puts "Set a minimum population: "
    @minimum_population = gets.chomp
    @minimum_population = @minimum_population.to_i
    puts "Set a maximum population: "
    @maximum_population = gets.chomp
    @maximum_population = @maximum_population.to_i
  end

  def get_distance_radius
    puts "Set a distance radius: "
    @distance = gets.chomp
    @distance = @distance.to_i
  end

  # def find_cities
  #   City.list_cities(@distance, @minimum_population, @maximum_population)
  # end

  def get_city
    puts "Set your city: "
    @city = gets.chomp
    City.set_starting_city(@city)
    CLI.welcome if !City.city
  end

  def populate_distances
    City.populate_distances(@distance)
  end

  def mass_yelp_search
    @city_array.each do |city|
      search = Search.new_query(@term, city)
      if !search.is_nil?
        @city_index_hash[city] = {}
        @city_index_hash[city][:avg_rating] = search.calculate_average
        @city_index_hash[city][:term] = @term
        @city_index_hash[city][:sum_of_reviews] = search.sum_of_reviews
      end
    end
    if city_index_hash[@term] == {}
      restart
    else
      best_city
      print_city
      sort_city
    end
  end

  def restart
    puts "We're sorry, your search didn't return any results. We are going to restart.\n\n\n"
    CLI.welcome
  end

  def best_city
    ratings_array = @city_index_hash.map {|key, value| value[:avg_rating]}.compact
    max_value = ratings_array.max
    best_city_hash = @city_index_hash.select do |city, data|
      data[:avg_rating] == max_value
    end
    @best_city = best_city_hash.keys.first
  end

  def sort_city
    ratings_array = @city_index_hash.map {|key, value| value[:avg_rating]}
    # reviews_array = @city_index_hash.map {|key, value| value[:sum_of_reviews]}.compact
    names_array = @city_index_hash.keys
    ratings_and_name_array = ratings_array.zip(names_array) # [4.2, "New York NY"]
    ratings_and_name_array = ratings_and_name_array.sort_by {|rating_review| rating_review.first}.reverse # This is the rating
    ratings_and_name_array.each_with_index do |rating_and_name, index|
      rating = rating_and_name.first
      name = rating_and_name.last
      hash = @city_index_hash.select do |city, data|
        data[:avg_rating] == rating && city == name
      end
      city_name = hash.keys.first
      sleep(2) if index < 20
      puts " \n#{index+1}. #{city_name} has an average rating of #{rating} out of #{hash[city_name][:sum_of_reviews]} reviews."
    end
    puts "\n"
  end

  def sum_of_reviews
    review_array = @city_index_hash.map {|city, data| data[:sum_of_reviews]}.compact
    review_array.reduce(:+)
  end

  def print_city
    puts " \nWe searched through #{@city_index_hash.count} cities and #{sum_of_reviews} reviews.\n "
    puts "#{@best_city} is the best city for #{@term} in #{@distance} miles with a population between #{@minimum_population} and #{@maximum_population}."
    sleep(5)
    #pause 10 seconds
  end
end
