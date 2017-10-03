require 'pry'

class Review < ActiveRecord::Base
  belongs_to :cities
end
