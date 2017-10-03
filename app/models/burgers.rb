require 'pry'

class Burger < ActiveRecord::Base
  belongs_to :restaurants
  belongs_to :cities, through: :restaurants

end
