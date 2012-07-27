class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :promotions
  attr_accessible :name, :street, :city, :state, :zip, :phone, :lat, :lng

  def address
    [street, city, state, zip].compact.join(', ')
  end

  validates :name,   :presence => true
  validates :street, :presence => true
  validates :city,   :presence => true
  validates :state,  :presence => true
  validates :zip,    :presence => true
  validates :phone,  :length => { :minimum => 10 }

  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode, :if => :street_changed? or :city_changed? or :state_changed? or :zip_changed?

end
