class YelpInfo < ActiveRecord::Base
  attr_accessible :identifier, :name, :mobile_url, :photo_url, :rating_img_url, :review_count, :url

  validates :identifier,     :presence => true, :uniqueness => true
  validates :name,           :presence => true
  validates :photo_url,      :format => { :with => /^http/ }
  validates :mobile_url,     :format => { :with => /^http/ }
  validates :url,            :format => { :with => /^http/ }
  validates :rating_img_url, :format => { :with => /^http/ }
  validates :review_count,   :inclusion => { :in => 0..10000 }

  after_validation :fetch_info, :if => :identifier_changed?

private
  def fetch_info
    self[:url] = "http://yahoo.com"
  end
end
