class YelpCategory < ActiveRecord::Base
  has_and_belongs_to_many :yelp_infos
  attr_accessible :name
  validates :name, :uniqueness => true
end
