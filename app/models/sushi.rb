require 'pry'

class Sushi < ActiveRecord::Base
  belongs_to :restaurants
  belongs_to :cities, through: :restaurants

end
