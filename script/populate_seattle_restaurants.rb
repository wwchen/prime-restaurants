#!/var/www/prime/script/rails runner

open(File.expand_path('../seattle.psv', __FILE__)).each_line do |res_info|
  name,street,city,state,zip,phone,lat,lng = res_info.split('|')
  begin
    Restaurant.create!(:name => name, :street => street, :city => city, :state => state, :zip => zip, :phone => phone)
  rescue
    next
  end
end
