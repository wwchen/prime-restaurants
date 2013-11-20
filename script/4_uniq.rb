#!/usr/bin/env ruby

require 'json'
require 'optparse'

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

ids = []
json.each_index do |i|
  info = json[i]
  id = info['name'].downcase.gsub(/[^0-9a-z ]/, '').split.join('-')
  if ids.index(id)
    num = 1
    begin
      num += 1
      newid = "#{id}-#{num}"
    end while not ids.index(newid).nil?
    id = "#{id}-#{num}"
  end
  ids.push(id)
  json[i]['id'] = id

  msg = "%d: %s - %s" % [i+1, id, info['name']]
  puts "\u2713 #{msg}".green
end

if out_fname
  File.open(out_fname, 'w') do |f|
    f.write(json.to_json)
  end
else
  puts json.to_json
end
