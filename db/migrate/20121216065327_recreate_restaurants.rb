class RecreateRestaurants < ActiveRecord::Migration
  def change
    drop_table :restaurants
    create_table :restaurants do |t|
      t.timestamps
      t.string   :name
      t.string   :street
      t.string   :city
      t.string   :state
      t.string   :zip
      t.string   :phone
      t.float    :lat
      t.float    :lng
    end
  end
end
