class YelpInfo < ActiveRecord::Base
  belongs_to :restaruant#, :inverse_of => :yelp_info
  has_and_belongs_to_many :yelp_categories

  #attr_accessible :identifier, :name, :mobile_url, :image_url, :rating_img_url, :review_count, :url
  attr_protected :restaurant_id

  validates :identifier,     :presence => true, :uniqueness => true
  validates :name,           :presence => true
#  validates :image_url,      :format => { :with => /^http/ }
#  validates :mobile_url,     :format => { :with => /^http/ }
#  validates :url,            :format => { :with => /^http/ }
#  validates :rating_img_url, :format => { :with => /^http/ }
#  validates :review_count,   :inclusion => { :in => 0..10000 }
  
  #  after_validation :fetch_info, :if => :identifier_changed?
  #self[:id] = :identifier
end
