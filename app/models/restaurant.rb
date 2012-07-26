class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :promotions
  attr_accessible :name, :street, :city, :state, :zip, :phone
  validates :name,   :presence => true
  validates :street, :presence => true
  validates :city,   :presence => true
  validates :state,  :presence => true
  validates :zip,    :presence => true
  validates :phone,  :length => { :minimum => 10 }
end
