class CLI
  attr_accessor :city_array, :term, :city, :city_index_hash, :distance, :maximum_population, :minimum_population

  @@term_hash = {}

  def initialize
    @city_index_hash = {}
    @term_hash = {}
    # get_city
    # populate_distances
    get_term
    get_population
    get_distance_radius
    @city_array = find_cities
    mass_yelp_search
    best_city
    print_city
  end

  def self.welcome
    new_search = CLI.new
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

  def find_cities
    City.list_cities(@distance, @minimum_population, @maximum_population)
  end

  def get_city
    puts "Set your city: "
    @city = gets.chomp
    # City.find_by(name: @city)
    City.set_starting_city(@city)
  end

  def populate_distances
    City.populate_distances
  end

  def mass_yelp_search
    @city_array.each do |city|
      search = Search.new_query(@term, city)
      city_index_hash[city] = search.calculate_average
    end
    @term_hash[@term] = city_index_hash
    @term_hash
  end

  def best_city
    max_value = @term_hash[@term].values.max
    hash = @term_hash[@term].select {|city, rating| rating == max_value}
    @best_city = hash.keys.first
  end

  def print_city
    puts "#{@best_city} is the best city for #{@term} in #{@distance} miles with a population between #{@minimum_population} and #{@maximum_population}."
  end
end
