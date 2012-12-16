#!/usr/bin/env ruby
require 'optparse'
require 'rubygems'
require 'nokogiri'
require 'json'


##
# Usage
##
$out_filetype = ""
OptionParser.new do |opts|
  opts.banner = "Usage: ./parse_primelist.rb -t [TYPE] <filename>"
  opts.on("-t", "--type [TYPE]", [:json, :txt, :psv], "Select output type (json, txt, psv)") do |v|
    $out_filetype = v
  end
  opts.on_tail("-h", "--help", "Show help") do
    puts opts
    exit
  end
  opts.on_tail("-V", "--version", "Show version") do
    puts OptionParser::Version.join('.')
    exit
  end
end.parse!

if ARGV.count < 1
  puts "No input filename!"
  exit
end

##
# Functions
##
def normalize(str)
  str.split(/[[:space:]]+/).join(' ').strip.delete("^\u{0000}-\u{007F}")
end

##
# Script
##
in_filename  = ARGV[0]
out_filename = /.*\..*?/.match(in_filename).to_s + $out_filetype

geocode = /\.psv$/i.match(out_filename)
if geocode
  require 'geocoder'
  require 'redis'

  #Geocoder::Configuration.lookup = :yahoo
  #Geocoder::Configuration.cache = Redis.new
  Geocoder::Configuration.timeout = 10
end





content = Nokogiri::HTML(open(in_filename))
vendors = content.xpath('//*[@id="Form1"]/table/tr[1]/td').css('table')
# vendors = content.xpath('//*[@id="Form1"]/table/tbody/tr[1]/td').css('table')
# vendors = vendors.count == 0? content.xpath('//*[@id="Form1"]/table/tr[1]/td').css('table')
if vendors.count == 0
  $stderr.puts "Can't find any vendors -- is it the right html?"
  exit
end

restaurants = Array.new
begin
vendors.each { |vendor| 
  vendor_info = vendor.css('font')
  name =  normalize(vendor_info[0].text)
  promo = vendor_info.css('li').collect { |i| i.text }
  info =  vendor_info.collect { |i| i.text }[1...-1]

  telephone = /[(]?\d{3}[\)-]?\s*?\d{3}[-. ]?\d{4}/.match(info[-1]).to_s
  address = normalize info[0...-1].join(', ')
  address = normalize info.join(', ') if telephone.empty?

  if geocode
    # retrieving a formatted address
    geo = Geocoder.search(address)[0]
    address = geo.formatted_address if geo.respond_to?("formatted_address")
    address = geo.address if address.nil?
    city = geo.city
    state = geo.state_code
    zip = geo.postal_code
    #street = [geo.address_components_of_type("street_number")[0]['long_name'], geo.address_components_of_type("route")[0]['long_name']].join(' ')
    street = address.sub(/(.*),?#{city}.*$/, '\1').strip
    lat = geo.latitude
    lng = geo.longitude
  else
    # splitting address
    addr_components = address.split(',')
    if addr_components.count < 3
      puts "#{name} failed"
      next
    else
      address = addr_components[-3].to_s.strip
      city    = addr_components[-2].to_s.strip
      state   = /[a-z]{2}/i.match(addr_components[-1]).to_s.strip
      zip     = /[0-9]{5}/i.match(addr_components[-1]).to_s.strip
    end
  end

  if geocode
    restaurants.push(Hash["name"=>name, "address"=>address, "street"=>street, "city"=>city, "state"=>state, "zip"=>zip, "lat"=>lat, "lng"=>lng, "telephone"=>telephone, "promotions"=>promo])
  elsif (defined? zip).nil?
    restaurants.push(Hash["name"=>name, "address"=>address, "telephone"=>telephone, "promotions"=>promo])
  else
    restaurants.push(Hash["name"=>name, "address"=>address, "city"=>city, "state"=>state, "zip"=>zip, "telephone"=>telephone, "promotions"=>promo])
  end
}
ensure
restaurants.uniq!

##
# Output
##
File.open(out_filename, 'w:UTF-8') { |f|
  case out_filename
  when /\.txt$/i
    restaurants.each { |restaurant|
      f.write(restaurant.collect{|i| i[1]}.join("\n") + "\n\n")
    }
  when /\.json$/i
    f.write(JSON.generate(restaurants))
  when /\.psv$/i
    restaurants.each { |res|
      f.write("#{res['name']}|#{res['street']}|#{res['city']}|#{res['state']}|#{res['zip']}|#{res['telephone']}|#{res['lat']}|#{res['lng']}\n")
    }
  end
  f.flush
}
end #begin..ensure..end
