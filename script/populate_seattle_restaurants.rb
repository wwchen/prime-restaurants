#!/usr/bin/env /Users/wchen/github/prime-map/script/rails runner

open(File.expand_path('../seattle.psv', __FILE__)).each_line do |res_info|
  name,street,city,state,zip,phone,lat,lng = res_info.split('|')
  begin
    Restaurant.first_or_create!(:name => name, :street => street, :city => city, :state => state, :zip => zip, :phone => phone)
  rescue
    next
  end
end
