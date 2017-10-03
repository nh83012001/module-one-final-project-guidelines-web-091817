require 'pry'

class Chinese < ActiveRecord::Base
  belongs_to :restaurants
  belongs_to :cities, through: :restaurants

end
