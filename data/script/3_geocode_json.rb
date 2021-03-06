#!/usr/bin/env ruby

require 'json'
require 'geocoder'
require 'optparse'

Geocoder::Configuration.timeout = 10
Geocoder::Configuration.lookup = :google

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
  msg = "%d: %s" % [i+1, info['name']]
  address = "%s, %s, %s %s" % [info['address'], info['city'], info['state'], info['zip']]
  begin
    result = Geocoder.search(address).first
    if result.nil?
      puts "\u2717 #{msg}".red
      sleep(3)
    end
  end while result.nil?

  json[i]['formatted_address'] = result.address #result.formatted_address
  json[i]['lat'] = result.latitude
  json[i]['lng'] = result.longitude
  puts "\u2713 #{msg}".green
end

if out_fname
  File.open(out_fname, 'w') do |f|
    f.write(json.to_json)
  end
else
  puts json.to_json
end
