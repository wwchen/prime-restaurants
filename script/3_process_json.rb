#!/usr/bin/env ruby

require 'json'
require 'geocoder'
require 'optparse'
require 'google_places'
require './levenshtein_distance'

GEOCODE = false
ZAGAT = true
PREFER_PLACES_LATLNG = true
DEBUG = false

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
  print "No output specified. JSON will be output in stdout. Are you sure? [Yn] "
  ans = gets
  ans = 'y' if ans == "\n"
  exit unless ans =~ /[yY]/
end

# determins the similarity (diff) percentage of two strings
def similarity(str1, str2)
  str1 = str1.to_s.downcase
  str2 = str2.to_s.downcase
  distance = levenshtein_distance(str1, str2)
  length = [str1.length, str2.length].max
  return (length - distance) / length.to_f
end

output = {}
count = 0
# FIXME
#json.each_with_index do |v, i|
json.each do |i, v|
  count += 1
  info = json[i]
  puts "== #{count}: #{info['name']} ====".yellow

  # uniq id names
  id = info['name'].downcase.gsub(/[^0-9a-z ]/, '').split.join('-')
  num = 1
  while output.has_key? id
    num += 1
    id = "#{id}-#{num}"
  end
  info['id'] = id
  puts "id: #{info['name']}".green

  # geocode
  if GEOCODE
    address = "%s, %s, %s %s" % [info['address'], info['city'], info['state'], info['zip']]
    result = nil
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
    puts "\u2713 geocoded - #{info['lat']}, #{info['lng']}".green
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

    puts "No Places result found!".red if results.empty?
    # go through all the results. continue only if the result is similar enough
    results.each { |result|
      continue = true

      # check the restaurant name (only the first half of it)
      begin
        index = [info['name'].length,    result.name.length].min / 2 + 1
        args =  [info['name'][0, index], result.name[0, index]]
        similar = similarity(*args).round(4)
        msg = "Name match of #{similar}: \"#{info['name']}\" and \"#{result.name}\""
        if similar < 0.7
          puts msg.red
          continue = false
        elsif similar < 1
          puts msg.yellow
        end
      end

      # check lat and lng
      begin
        lat = (info['lat'] - result.lat).abs.round(5)
        lng = (info['lng'] - result.lng).abs.round(5)
        msg = "LatLng difference of #{lat}/#{lng}: (#{info['lat']} #{info['lng']}) and (#{result.lat}, #{result.lng})"
        if lat > 1e-3 and lng > 1e-3
          puts msg.red
          continue = false
        elsif lat > 1e-4 and lng > 1e-4
          puts msg.yellow
        end
      end

      if continue
        # this is the result we are looking for
        # replace the more accurate lat/lng
        info.merge!({
          'lat'               => result.lat,
          'lng'               => result.lng,
          #'formatted_address' => result.formatted_address,
          'rating'            => result.rating,
          'gplaces_ref'       => result.reference
        })

        # debugging
        if DEBUG
          puts "========"
          %w(name lat lng).each { |i|
            puts "#{i}: #{info[i]} \t#{result[i]} \t#{similarity(info[i], result[i])}"
          }
          puts "addr: #{info['formatted_address']} \t#{result.vicinity} \t#{similarity(info['formatted_address'], result.vicinity)}"
          puts "rating: #{result.reviews}"
          puts "reference: #{result.reference}"
          puts "========"
        end

        puts "reference: #{info['gplaces_ref']}".green
        puts "rating of #{info['rating']}".green
        break
      end
    }
  end

  output[id] = info
  puts "== #{count}: \u2713 ==\n".green
end

if out_fname
  File.open(out_fname, 'w') do |f|
    f.write(output.to_json)
  end
else
  puts output.to_json
end
