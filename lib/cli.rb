require 'pry'
require 'tty-spinner'

# Removes logging text
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

class CLI
  attr_accessor :city_array, :city_index_hash
  attr_accessor :distance, :maximum_population, :minimum_population, :term, :city

  def initialize
    @city_index_hash = {}
    get_user_input
    list_cities_within_population
    add_array(populate_distances)
    approve_query_length
  end

  def self.welcome
    puts " \nHi and Welcome to CityYelp.\n "
    puts " \nWould you like to make a search or lookup an existing city?\n "
    puts " \n1. New Search"
    puts "2. Lookup Existing City\n "
    choice = gets.chomp
    CLI.new if choice.to_i == 1
    lookup_city_ratings if choice.to_i == 2
  end

  def self.lookup_city_ratings
    puts " \nWhich city would you like to lookup existing ratings for?\n "
    city_choice = gets.chomp
    Rating.list_city_ratings(city_choice)
    sleep(5)
    self.welcome
  end

  def restart
    puts "We're sorry, your search didn't return any results. We are going to restart.\n\n\n"
    CLI.new
  end

  def list_cities_within_population
    City.list_cities_within_population(@minimum_population, @maximum_population)
  end

  def approve_query_length
    puts " \nThere are #{City.query_count} cities that are within #{distance} miles of #{city} that are between #{minimum_population} and #{maximum_population} people."
    puts "Would you like to proceed with the search? Type 'Y' or 'N'."
    user_response = gets.chomp
      if user_response == "Y"
        mass_yelp_search
      elsif user_response == "N"
        CLI.new
      else
        user_response = gets.chomp
      end
  end

  def get_user_input
    get_city
    get_term
    set_population_size
    get_distance_radius
  end

  def add_array(city_array)
    @city_array = city_array
  end

  def get_term
    puts " \nGive a term to search: "
    @term = gets.chomp
  end

  def set_population_size
    puts " \nSet a population range:"
    puts "1. Small Town (< 1,000)"
    puts "2. Town: (1,000 to 50,000)"
    puts "3. Small City: (50,000 to 250,000)"
    puts "4. City: (250,000 to 1,000,000)"
    puts "5. Large City: (1,000,000+)\n "
    input = gets.chomp
    case input.to_i
    when 1
      @minimum_population = 0
      @maximum_population = 1000
    when 2
      @minimum_population = 1000
      @maximum_population = 50000
    when 3
      @minimum_population = 50000
      @maximum_population = 250000
    when 4
      @minimum_population = 250000
      @maximum_population = 1000000
    when 5
      @minimum_population = 1000000
      @maximum_population = 20000000
    end
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
    puts " \nSet a distance radius: "
    @distance = gets.chomp
    @distance = @distance.to_i
  end

  def get_city
    puts " \nSet your city: "
    @city = gets.chomp
    City.set_starting_city(@city)
    CLI.new if !City.city
  end

  def populate_distances
    City.populate_distances(@distance)
  end

  def mass_yelp_search
    puts "\n"
    @spinner = TTY::Spinner.new(":spinner :spinner :spinner :spinner :spinner ......THINKING...... :spinner :spinner :spinner :spinner :spinner", format: :dots)
    @spinner.auto_spin
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
      update_ratings_table # Updates the ratings table
      find_best_city
      print_city
      sort_cities
      top_ten_in_best_city
    end
  end

  def update_ratings_table
    # Use key to find city_id from cities table
    @city_index_hash.each do |city, data|
      id = City.find_by(name: city).id
      if Rating.where("city_id = ? and term = ?", id, data[:term]) == []
        Rating.create(
          city_id: id,
          avg_rating: data[:avg_rating],
          sum_of_reviews: data[:sum_of_reviews],
          term: data[:term]
        )
      end
    end
  end

  def top_ten_in_best_city
    search = Search.new_query(@term, @best_city)
    search.print_results(5)
    self.class.welcome
  end

  def find_best_city
    ratings_array = @city_index_hash.map {|key, value| value[:avg_rating]}.compact
    max_value = ratings_array.max
    best_city_hash = @city_index_hash.select do |city, data|
      data[:avg_rating] == max_value
    end
    @best_city = best_city_hash.keys.first
  end

  def sort_cities
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
      sleep(1) if index < 20
      puts " \n#{index+1}. #{city_name} has an average rating of #{rating} out of #{hash[city_name][:sum_of_reviews]} reviews."
    end
    puts "\n"
    sleep(5)
  end

  def sum_of_reviews
    review_array = @city_index_hash.map {|city, data| data[:sum_of_reviews]}.compact
    review_array.reduce(:+)
  end

  def print_city
    @spinner.stop('THOUGHT!')
    puts " \nWe searched through #{@city_index_hash.count} cities and #{sum_of_reviews} reviews.\n "
    puts "#{@best_city} is the best city for #{@term} in #{@distance} miles with a population between #{@minimum_population} and #{@maximum_population}."
    sleep(3)
  end

end
