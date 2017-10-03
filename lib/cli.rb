class CLI
  attr_accessor :term, :first_city, :second_city

  def initialize
    get_input
    yelp_search
  end

  def self.welcome
    new_search = CLI.new
  end

  def yelp_search
    first_instance = Search.new_query(@term, @first_city)
    first_instance.print_average

    second_instance = Search.new_query(@term, @second_city)
    second_instance.print_average
  end

  def get_input
    puts "Name a Search Term: \n "
    @term = gets.chomp
    puts "Name a City: "
    @first_city = gets.chomp
    puts "Name another City to compare:"
    @second_city = gets.chomp
  end
end

  #how many miles are you willing to drive
  def distance_parameter
    puts "How far are you willing to drive from your current location?"
    response = gets.chomp
    find_distance_options(response)
  end

  #popluation (min = nil, max = nil)
  def population_parameter #maybe do small/medium/large 10k-100k, 100k-1m, >1m
    puts "Please give a population range for the type of city/town you would like to visit"
    puts "Minimum"
    minimum = gets.chomp
    puts "Maximum"
    maxium = gets.chomp
    find_population_options(minimum, maximum)
  end

#   #what items do you care about from yelp?
#   def yelp_parameter
#     puts "What of the following do you care about?"
#     #puts out an organized/numbered list of options
#     #need to tell them to respond in an array?
#     response = gets.chomp#should be an array of numbers
#   end
#
#   def find_distance_options(distance)
#
#   end
#
#   def find_population_options(minimum = nil, maximum = nil)
#
#
#   end
#
#   def display
#     #end with a paragraph and list of top restaurants or museums, what city it's in, distance, etc.
#   end
#
#
# end
