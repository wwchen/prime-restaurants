require 'mechanize'

agent = Mechanize.new
agent.follow_meta_refresh = true

page = agent.get 'http://microsoftprime.com/'
# wa_option = page.form.field_with(:name => 'ddlRegion').option_with(:text => 'Washington - Western')
all_page = page.form.click_button(page.form.button_with(:name => 'cmdRegionGo'))
food_page = all_page.link_with(:text => %r/food/i).click
restaurant_page = food_page.link_with(:text => %r/restaurant/i).click
print_page = restaurant_page.link_with(:text => 'Print-Ready').click
print_page.save_as 'restaurants.html'
