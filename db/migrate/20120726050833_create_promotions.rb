class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :detail
      t.boolean :bogo
      t.references :restaurant

      t.timestamps
    end
    add_index :promotions, :restaurant_id
  end
end
