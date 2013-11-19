#!/usr/bin/env ruby

require 'json'
require 'geocoder'
require 'optparse'

Geocoder::Configuration.timeout = 10
Geocoder::Configuration.lookup = :google

out_fname = nil
OptionParser.new do |opts|
  opts.banner = "Usage: ./geocode_json.rb -o <output> <filename>"
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


json.each_index do |i|
  info = json[i]
  address = "%s, %s, %s %s" % [info['address'], info['city'], info['state'], info['zip']]
  begin
    result = Geocoder.search(address).first
    puts "\u2717 %d: %s" % [i+1, info['name']]
    sleep(3) if result.nil?
  end while result.nil?

  json[i]['formatted_address'] = result.address #result.formatted_address
  json[i]['lat'] = result.latitude
  json[i]['lng'] = result.longitude
  puts "\u2713 %d: %s" % [i+1, info['name']]
end

if out_fname
  File.open(out_fname, 'w') do |f|
    f.write(json.to_json)
  end
else
  puts json.to_json
end
