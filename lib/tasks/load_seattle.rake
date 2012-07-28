namespace :db do
  desc "Loads the Seattle restaurants data into the database"
  task :load_seattle => :environment do
    path = ENV['path']
    if path
      puts "Reading the file at #{path}"
      open(path).each_line do |res_info|
        name,street,city,state,zip,phone,lat,lng = res_info.split('|')
      #  begin
          Restaurant.first_or_create!(:name => name, :street => street, :city => city, :state => state, :zip => zip, :phone => phone)
      #  rescue
      #    next
      #  end
      end
    else
      puts "You didn't specify a path to the PSV (pipe separated values) file."
      puts "Use \"rake db:load_seattle path=<path_to_file>\" in the future."
    end
  end

end
