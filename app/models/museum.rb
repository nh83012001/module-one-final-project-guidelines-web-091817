require 'pry'

class Museum < ActiveRecord::Base
  belongs_to :cities

end
