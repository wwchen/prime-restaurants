require 'action_controller'

class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :promotions
  attr_accessible :name, :street, :city, :state, :zip, :phone, :lat, :lng

  validates :name,   :presence => true
  validates :street, :presence => true
  validates :city,   :presence => true
  validates :state,  :presence => true
  validates :zip,    :presence => true
  validates :phone,  :length => { :minimum => 10 },
                     :format => { :message => "must be a valid telephone number.",
                                  :with => /^[\(\)0-9\- \+\.]{10,20}$/}

  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode, :if => :street_changed? or :city_changed? or :state_changed? or :zip_changed?
  after_validation :format_phone

  def address
    [street, city, state, zip].compact.join(', ')
  end

  def format_phone
    self[:phone] = ActionController::Base.helpers.number_to_phone(phone, :area_code => true, :delimiter => '-', :raise => true)
  end
end
