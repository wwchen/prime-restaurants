class AddRestaurantReference < ActiveRecord::Migration
  def up
    add_column :yelp_infos, :restaurant_id, :integer
  end
  def down
    remove_column :yelp_infos, :restaurants_id
  end
#  def change
#    change_table :yelp_infos do |t|
#      t.references  :restaurants
#    end
#  end
end
