class CreatePromotionRestaurantJoinTable < ActiveRecord::Migration
  def change
    create_table :promotions_restaurants, :id => false do |t|
      t.integer :promotion_id
      t.integer :restaurant_id
    end
    add_index :promotions_restaurants, [:promotion_id, :restaurant_id]
    add_index :promotions_restaurants, [:restaurant_id, :promotion_id]
  end
end
