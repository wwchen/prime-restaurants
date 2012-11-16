#!/usr/bin/env ruby

require 'mechanize'

out_filename = ARGV.count < 1? 'restaurants.html' : ARGV[0]
region = ARGV.count < 2? '-1' : ARGV[1]

if ARGV.count < 2
  puts "Usage: ./crawl_microsoftprime.rb <output-filename> <region-number>"
  puts "No filename specified, using default filename, " + out_filename if ARGV.count < 1
  puts "No region number specified, using default id, " + region        if ARGV.count < 2
  puts "\n"
end

agent = Mechanize.new
agent.follow_meta_refresh = true

page = agent.get 'http://microsoftprime.com/'
# wa_option = page.form.field_with(:name => 'ddlRegion').option_with(:text => 'Washington - Western')
page.form.field_with(:name => 'ddlRegion').value = region # wa_option # washington - western
all_page = page.form.click_button(page.form.button_with(:name => 'cmdRegionGo'))
food_page = all_page.link_with(:text => %r/food/i).click
restaurant_page = food_page.link_with(:text => %r/restaurant/i).click
print_page = restaurant_page.link_with(:text => 'Print-Ready').click
print_page.save_as out_filename
