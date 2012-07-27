class AddLatLngToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :lat, :float
    add_column :restaurants, :lng, :float
  end
end
