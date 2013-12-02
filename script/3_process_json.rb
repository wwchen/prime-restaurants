#!/usr/bin/env ruby

require 'json'
require 'geocoder'
require 'optparse'
require 'google_places'
require './levenshtein_distance'

GEOCODE = false
ZAGAT = true
PREFER_PLACES_LATLNG = true
DEBUG = true

Geocoder::Configuration.timeout = 10
Geocoder::Configuration.lookup = :google
GOOGLE_PLACES_API_KEY = 'AIzaSyDEfet-YacBhc1yYnyiYXaDdRnTUdpVyL0'

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def red
    colorize(31)
  end
  def green
    colorize(32)
  end
  def yellow
    colorize(33)
  end
end

out_fname = nil
OptionParser.new do |opts|
  opts.banner = "Usage: ./3_process_json.rb -o <output> <filename>"
  opts.on('-o', '--output <filename>', 'Write output to <filename> instead of stdout') do |v|
    out_fname = v.strip
  end
  opts.on_tail("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

if ARGV.count < 1
  puts "No filename specified. See help with -h flag"
  exit
end

fname = ARGV.shift
json = JSON.parse(File.read(fname))

unless out_fname
  print "No output specified. JSON will be output in stdout. Are you sure? [yN] "
  ans = gets
  exit unless ans =~ /[yY]/
end

# determins the similarity (diff) percentage of two strings
def similarity(str1, str2)
  # TODO placeholder
  return 1 if str1 == str2
  return 0
end

output = {}
# FIXME
#json.each_with_index do |v, i|
json.each do |i, v|
  info = json[i]

  # uniq id names
  id = info['name'].downcase.gsub(/[^0-9a-z ]/, '').split.join('-')
  num = 1
  while output.has_key? id
    num += 1
    id = "#{id}-#{num}"
  end
  info['id'] = id
  #msg = "%d: %s - %s" % [i+1, id, info['name']]
  msg = "%d: %s - %s" % [1, id, info['name']]

  # geocode
  if GEOCODE
    address = "%s, %s, %s %s" % [info['address'], info['city'], info['state'], info['zip']]
    begin
      result = Geocoder.search(address).first
      if result.nil?
        puts "\u2717 #{msg}".red
        sleep(3)
      end
    end while result.nil?
    info.merge!({
      'formatted_address' => result.address, #result.formatted_address
      'lat' => result.latitude,
      'lng' => result.longitude,
      'id' => id
    })
  end

  # zagat - google places api
  if ZAGAT
    # https://developers.google.com/places/documentation/
    # http://rubydoc.info/gems/google_places/0.20.0/frames
    client = GooglePlaces::Client.new(GOOGLE_PLACES_API_KEY)
    results = client.spots(info['lat'].to_f, info['lng'].to_f,
      :keyword => info['name'],
      :radius => 50,
      :types => 'restaurant'
    )

    results.each { |result|
#      if similarity(info['name'], result.name) >= 0.8 and
#         similarity(info['lat'],  result.lat)  >= 0.8 and
#         similarity(info['lng'],  result.lng)  >= 0.8 and
#         similarity(info['formatted_address'], result.formatted_address) >= 0.8
      if true
        # this is the result we are looking for
        
        # replace the more accurate lat/lng
        info.merge!({
          :lat               => result.lat,
          :lng               => result.lng,
          :formatted_address => result.formatted_address,
          :rating            => result.rating,
          :gplaces_ref       => result.reference
        })

        # debugging
        if DEBUG
          puts "========"
          puts "name: #{info['name']} #{result.name}"
          puts "lat: #{info['lat']} #{result.lat}"
          puts "lng: #{info['lng']} #{result.lng}"
          puts "addr: #{info['formatted_address']} #{result.formatted_address}"
          puts "rating: #{result.reviews}"
          puts "reference: #{result.reference}"
          puts "========"
        end

        break
      end
    }
  end

  output[id] = info
  puts "\u2713 #{msg}".green
end

if out_fname
  File.open(out_fname, 'w') do |f|
    f.write(output.to_json)
  end
else
  puts output.to_json
end
