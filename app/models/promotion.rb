class Promotion < ActiveRecord::Base
  has_and_belongs_to_many :restaurant
  attr_accessible :bogo, :detail
end
