#!/usr/bin/env ruby

require 'mechanize'
require 'optparse'

agent = Mechanize.new
agent.follow_meta_refresh = true
region = -1

OptionParser.new do |opts|
  opts.banner = "Usage: ./crawl_microsoftprime.rb [-r] <output-filename>"

  opts.on("-l", "--list-regions", "List all available regions") do |v|
    page = agent.get 'http://microsoftprime.com'
    form = page.forms_with(:id => "form6").first
    regions = form.field_with(:name => 'txtRegion')
    regions.options.each do |region|
      puts "#{region}\t#{region.text}"
    end
    exit
  end
  opts.on("-r", "--region [ID]", String, "Region value to crawl") do |v|
    region = v
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

out_filename = ARGV.count < 1? 'restaurants.html' : ARGV[-1]
if ARGV.count < 1
  puts "No filename specified, using default filename, " + out_filename
end

page = agent.get 'http://microsoftprime.com/'

form = page.forms_with(:id => "form6").first
region_selectlist = form.field_with(:name => 'txtRegion')
region_option = region_selectlist.option_with(:value => region)

if region_option.nil?
  puts "Invalid region value"
  exit
end

puts "Selecting region #{region_option.text}"
region_selectlist.value = region
all_page = page.form.click_button(page.form.button_with(:name => 'cmdRegionGo'))
food_page = all_page.link_with(:text => %r/food/i).click
restaurant_page = food_page.link_with(:text => %r/restaurant/i).click
print_page = restaurant_page.link_with(:text => 'Print-Ready').click
print_page.save_as out_filename
