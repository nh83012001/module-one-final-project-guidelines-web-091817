require 'pry'

class City < ActiveRecord::Base
  has_many :bars, :museums, :restaurants
  has_many :breakfasts, through: :restaurants


end
