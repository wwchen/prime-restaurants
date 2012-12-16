#!/usr/bin/env /Users/wchen/github/prime-map/script/rails runner
#!/usr/bin/env PATH="$PATH:$PWD" rails runner

require 'json'

if ARGV.count < 1
  puts "Usage: ./populate_database.rb <filename>"
  exit
end

fname = ARGV[0]

json = JSON.parse(File.read(File.expand_path("../#{fname}", __FILE__)))

# json is assumed to be in the following format:
# name(string), address(string), city(string), state(string), zip(string), telephone(string), promotions(list)

json.each do |res|
  begin
    restaurant = Restaurant.find_or_create_by_name_and_street_and_zip(
                    :name   => res['name'],
                    :street => res['address'],
                    :city   => res['city'],
                    :state  => res['state'],
                    :zip    => res['zip'],
                    :phone  => res['telephone'])
    res['promotions'].each do |promo|
      promotion = Promotion.find_or_create_by_detail(promo)
      restaurant.promotions << promotion
    end
  rescue
    next
  end
end
