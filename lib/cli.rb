class CLI
  attr_accessor :city_array, :term, :first_city, :second_city, :city_index_hash

  @@term_hash = {}

  def initialize
    @city_index_hash = {}
    test_data
  end

  def self.welcome
    new_search = CLI.new
  end

  def add_array(city_array)
    @city_array = city_array
  end

  def update_term(term)
    @term = term
  end

  def test_data
    @city_array = ["Austin TX", "New York City"]
    @term = "tacos"
    mass_yelp_search
  end

  def mass_yelp_search
    @city_array.each do |city|
      search = Search.new_query(@term, city)
      city_index_hash[city] = search.calculate_average
    end
    @@term_hash[term] = city_index_hash
  end
end
