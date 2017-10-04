#makes all the calls to api
#make calls to CSV

#only parses out the stuff we majorly don't need (how to use the API)
#then the class pulls exactly what it needs from that

# I repurposed the yelp code with only what we need and I turned it
# into a class so that it's more malleable

# It works. I tested it at the bottom by comparing pizza in NYC
# and Boston. NYC has a higher rating which means it must work

require 'pry'
require 'json'
require 'http'
require 'optparse'
require 'pry'

# Authentication for the Yelp API
CLIENT_ID = "LvnmmaOiGVGD8KJWl3F9Jw"
CLIENT_SECRET = "o2npCNvvrQxpPJ33KosFKFdZ0ZnWCZQqFoPlu1k5SFtR0SOR2GpypziSXKe2XkeV"

# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"

# This is the number of results returned
SEARCH_LIMIT = 50

class Adapter

  def initialize(term, location)
    @search = search
    @location = location
  end

  def self.search(term, location, price)
    url = "#{API_HOST}#{SEARCH_PATH}"

    params = set_params({term: term, location: location, price: price})

    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
  end

  def self.set_params(params)
    params = {
      term: params[:term],
      location: params[:location],
      limit: SEARCH_LIMIT, # The search return max is 50
      price: params[:price]
    }
  end

  private

  def self.bearer_token
    url = "#{API_HOST}#{TOKEN_PATH}"

    params = {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      grant_type: GRANT_TYPE
    }

    response = HTTP.post(url, params: params)
    parsed = response.parse

    "#{parsed['token_type']} #{parsed['access_token']}"
  end
end

class Search < Adapter
  attr_accessor :term, :location, :results
  attr_reader :average_rating, :price

  def initialize(term, location)
    @term = term
    @location = location
  end

  def self.new_query(term, location)
    Search.new(term, location)
  end

  def set_price(price)
    raise "Fixnum Required" if price.class != Fixnum
    @price = price
  end

  def all_ratings
    ratings = []
    # Finds all the ratings for each price
    (1..4).to_a.each do |price|
      set_price(price)
      ratings << count_ratings
    end
    ratings.flatten
  end

  def all_reviews
    reviews = []
    (1..4).to_a.each do |price|
      set_price(price)
      reviews << count_reviews
    end
    reviews.flatten
  end

  def search_query
    @results = self.class.search(@term, @location, @price)
  end

  def format_results
    search_query if !results
    results["businesses"]
  end

  def print_results
    puts "Showing results for #{term} in #{location}\n\n"
    format_results.each do |business|
      puts "Name: #{business["name"]}"
      puts "Rating: #{business["rating"]}"
      puts "Review Count: #{business["review_count"]}"
      puts "Price: #{business["price"]}"
    end
    puts "\n\n"
  end

  def count_ratings
    format_results.map {|business| business["rating"] * business["review_count"]}
  end

  def count_reviews
    format_results.map {|business| business["review_count"]}
  end

  def collect_ratings
    all_ratings
  end

  def collect_reviews
    all_reviews
  end

  def sum_of_ratings
    collect_ratings.reduce(:+)
  end

  def sum_of_reviews
    collect_reviews.reduce(:+)
  end

  def is_nil?
    !sum_of_ratings || !sum_of_reviews
  end

  def calculate_average
    average_rating = sum_of_ratings / sum_of_reviews
    average_rating.round(3) # 4.31
  end

  def print_average
    puts "#{term.capitalize} have an average of #{calculate_average} out of #{sum_of_reviews} reviews in #{location}\n "
  end
end
