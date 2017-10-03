require 'pry'

class City < ActiveRecord::Base
  has_many :reviews

end
