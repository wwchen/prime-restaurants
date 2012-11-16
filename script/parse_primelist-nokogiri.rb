#!/usr/bin/env ruby

if ARGV.count < 2
  puts "Usage: ./parse_primelist.rb <filename> <output-name.ext>"
  puts "Output extensions: json, txt, psv, sqlite3"
  exit
end

in_filename = ARGV[0]
out_filename = ARGV[1] #txt json sqlite3 psv

require 'rubygems'
require 'nokogiri'
require 'json'    if /\.json/.match(out_filename)
require 'sqlite3' if /\.sqlite3/.match(out_filename)

if /\.psv/.match(out_filename)
  require 'geocoder'
  require 'redis'

  Geocoder::Configuration.lookup = :yahoo
  #Geocoder::Configuration.cache = Redis.new
  Geocoder::Configuration.timeout = 10
end

def normalize(str)
  str.split(/[[:space:]]+/).join(' ').strip.delete("^\u{0000}-\u{007F}")
end

content = Nokogiri::HTML(open(in_filename))
vendors = content.xpath('//*[@id="Form1"]/table/tr[1]/td').css('table')
# vendors = content.xpath('//*[@id="Form1"]/table/tbody/tr[1]/td').css('table')
# vendors = vendors.count == 0? content.xpath('//*[@id="Form1"]/table/tr[1]/td').css('table')
if vendors.count == 0
  $stderr.puts "Can't find any vendors -- is it the right html?"
  exit
end

restaurants = Array.new
begin
vendors.each { |vendor| 
  vendor_info = vendor.css('font')
  name =  normalize(vendor_info[0].text)
  promo = vendor_info.css('li').collect { |i| i.text }
  info =  vendor_info.collect { |i| i.text }[1...-1]

  telephone = /[(]?\d{3}[\)-]?\s*?\d{3}[-. ]?\d{4}/.match(info[-1]).to_s
  address = normalize info.join(', ') if telephone.empty?
  address = normalize info[0...-1].join(', ')


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

  if geocode
    restaurants.push(Hash["name"=>name, "address"=>address, "street"=>street, "city"=>city, "state"=>state, "zip"=>zip, "lat"=>lat, "lng"=>lng, "telephone"=>telephone, "promotions"=>promo])
  else
    restaurants.push(Hash["name"=>name, "address"=>address, "telephone"=>telephone, "promotions"=>promo])
  end
}
ensure
restaurants.uniq!

# output
case out_filename
  when /\.(txt|json|psv)$/i
    File.open(out_filename, 'w:UTF-8') { |f|
      if out_filename =~ /\.txt$/i
        restaurants.each { |restaurant|
          f.write("#{restaurant["name"]}\n#{restaurant["address"]}\n#{restaurant["telephone"]}\n#{restaurant["promotions"]}\n\n")
        }
      elsif out_filename =~ /\.json$/i
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
