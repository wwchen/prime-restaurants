#!/usr/bin/env ruby

if ARGV.count < 2
  puts "Usage: ./parse_primelist.rb <filename> <output-type>"
  puts "Output type: json, txt, psv"
  exit
end

require 'htmlentities'
require 'json'
require 'sqlite3'

geocode = false

in_filename = ARGV[0]
out_filename = ARGV[1] #txt json sqlite3 psv

if geocode
  require 'geocoder'
  require 'redis'

  Geocoder::Configuration.lookup = :yahoo
  #Geocoder::Configuration.cache = Redis.new
  Geocoder::Configuration.timeout = 10
end

## Functions
def strip_html(code)
  HTMLEntities.new.decode(code.gsub(/<.*?>/m, ' ')).gsub(/\s+/, ' ').strip
end

# Open the file
content = open(in_filename).read

# Match everything between <!-- VENDOR INFO --> and <!-- END OF VENDOR INFO -->
vendors = content.scan(/<!-- VENDOR INFO -->(.*?)<!-- END OF VENDOR INFO -->/m).flatten!

restaurants = Array.new
begin
vendors.each { |vendor| 
  vendor.gsub!('&nbsp;', '')
  vendor_info = vendor.scan(/<div.*?>.+?<\/div>/m)
  # first div is name
  name = strip_html(vendor_info[0])

  # second div is address and telephone number
  address = strip_html(vendor_info[1])
  telephone = /[(]?\d{3}[\)-]?\s*?\d{3}[-. ]?\d{4}/.match(address).to_s
  address.sub!(/#{Regexp.escape(telephone)}/, '').strip!

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
  end

  # third div is promotion details
  promotions = Array.new
  vendor_info[2].scan(/<li.*?>.+?<\/li>/).each { |promo|
    promotions.push HTMLEntities.new.decode(strip_html(promo))
  }
   
  if geocode
    restaurants.push(Hash["name"=>name, "address"=>address, "street"=>street, "city"=>city, "state"=>state, "zip"=>zip, "lat"=>lat, "lng"=>lng, "telephone"=>telephone, "promotions"=>promotions])
  else
    restaurants.push(Hash["name"=>name, "address"=>address, "telephone"=>telephone, "promotions"=>promotions])
  end
}
ensure
restaurants.uniq!

# output
case out_filename
  when /\.(txt|json|psv)$/i
    File.open(out_filename, 'w') { |f|
      if out_filename =~ /\.txt$/i
        restaurants.each { |restaurant|
          f.write("#{restaurant["name"]}\n#{restaurant["address"]}\n#{restaurant["telephone"]}\n#{restaurant["promotions"]}\n\n")
        }
      elseif out_filename =~ /\.json$/i
        f.write(JSON.generate(restaurants))
      else
        restaurants.each { |res|
          f.write("#{res['name']}|#{res['street']}|#{res['city']}|#{res['state']}|#{res['zip']}|#{res['telephone']}|#{res['lat']}|#{res['lng']}\n")
        }
      end
      f.flush
    }
  when /\.sqlite3$/i
    db = SQLite3::Database.new(out_filename)
    db.execute("create table restaurants( id INTEGER PRIMARY KEY, name TEXT, telephone TEXT, address TEXT,
                 promo1 TEXT, promo2 TEXT, promo3 TEXT, promo4 TEXT, promo5 TEXT, lat REAL, lng REAL)")
    restaurants.each { |res|
      res['promotions'].each_with_index { |promo, i|
        res["promo#{i+1}"] = promo.gsub(/"/,"'")
      }
      res.delete('promotions')
      db.execute("insert into restaurants (#{res.keys.join(', ')}) values (\"#{res.values.join('", "')}\")")
    }
#    count = 0
#    restaurants.each { |res|
#      count += 1
#      db.execute("insert into restaurants (name, address, telephone) values 
#                  ('#{res['name']}', '#{res['address']}', '#{res['telephone']}')")
#      min = [res['promotions'].length-1, 4].min.abs
#      0.upto(min) { |i|
#        promo = "#{res['promotions'][i]}".gsub(/'/,'"')
#        db.execute("update restaurants set promo#{i+1} = '#{promo}' where id=#{count}")
#      }
#    }
  end
end #begin..ensure..end
