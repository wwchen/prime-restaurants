require 'action_controller'
# require 'yelp'

class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :promotions
#  has_one :yelp_info, :dependent => :destroy#, :inverse_of => :restaurant
  attr_accessible :name, :street, :city, :state, :zip, :phone, :lat, :lng

  validates :name,   :presence => true, :uniqueness => { :scope => :street }
  validates :street, :presence => true, :uniqueness => { :scope => :zip }
  validates :city,   :presence => true
  validates :state,  :presence => true
  validates :zip,    :presence => true, :length => { :is => 5 }
#  validates :phone,  :length => { :is => 14 }
#                     :format => { :message => "must be a valid telephone number.",
#                                  :with => /[(]?\d{3}[\)-]?\s*?\d{3}[-. ]?\d{4}/ }

  geocoded_by :address, :latitude => :lat, :longitude => :lng
  before_validation :formatting
  after_validation :geocode, :if => :street_changed? or :city_changed? or :state_changed? or :zip_changed? # or :lat_empty?
  after_validation :trim
#  before_save :fetch_yelp

  def address
    [street, city, state, zip].compact.join(', ')
  end

  def formatting
    self[:zip] = zip.sub(/-.*/,'') unless zip.nil?
    self[:phone] = ActionController::Base.helpers.number_to_phone(phone.gsub(/[^0-9]/,''), :area_code => true, :delimiter => '-', :raise => true) unless phone.nil?
  end

  def trim
    [name,street,city,state,zip].each { |f| f.strip! }
  end

#  def fetch_yelp
#    info = Yelp::Search.new(Yelp::Request.location(:location => address)).request.get_first_result
#    #self.yelp_info = YelpInfo.create(info) unless info.nil?
#    #self.create_yelp_info(info.get_first_result, :without_protection => true)
#    info.delete_if { |k,v| not %(id, name, image_url, mobile_url, url, rating_img_url, review_count).include?(k) }
#    info[:identifier] = info['id']
#    info.delete('id') and info.delete('rating')
#    puts info
#    self.create_yelp_info(info)
#  end
end
