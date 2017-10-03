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

  def self.search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
      term: term,
      location: location,
      limit: SEARCH_LIMIT # The search return max is 50
    }

    response = HTTP.auth(bearer_token).get(url, params: params)
    response.parse
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
  attr_reader :average_rating

  def initialize(term, location)
    @term = term
    @location = location
  end

  def self.new_query(term, location)
    Search.new(term, location)
  end

  def search_query
    @results = self.class.search(@term, @location)
  end

  def format_results
    search_query if !results
    results["businesses"]
  end

  def collect_ratings
    format_results.map {|business| business["rating"]}
  end

  def calculate_average
    sum_of_ratings = collect_ratings.inject(0) {|sum, n| sum + n}
    average_rating = sum_of_ratings / collect_ratings.count
  end

  def print_average
    puts "#{term} in #{location} is #{calculate_average}"
  end
end

# Test Case
pizza_new_york = Search.new_query("pizza", "New York City")
pizza_new_york.print_average
# => Returns 4.28

pizza_boston = Search.new_query("pizza", "Boston")
pizza_boston.print_average
# => Returns 4.05
