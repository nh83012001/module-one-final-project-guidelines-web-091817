require 'pry'

class Restaurant < ActiveRecord::Base
  belongs_to :cities
  has_many :breakfasts, :italians, :chineses, :breakfasts, :sushis, :thais, :burgers


end
