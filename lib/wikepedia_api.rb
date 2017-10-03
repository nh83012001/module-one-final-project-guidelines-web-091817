require 'pry'
require 'net/http'
require 'pry'
require 'rest-client'
require 'json'

basic = RestClient.get('https://en.wikipedia.org/w/api.php?action=query&titles=Main%20Page&prop=revisions&rvprop=content&format=json')
binding.pry

 BASE_URL = 'https://en.wikipedia.org/w/api.php'
 all_characters = RestClient.get("#{BASE_URL}/people/")


data = Net::HTTP.get('https://en.wikipedia.org/w/api.php?action=query&titles=Main%20Page&prop=revisions&rvprop=content&format=json')
