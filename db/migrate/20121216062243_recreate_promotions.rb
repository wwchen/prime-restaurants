class RecreatePromotions < ActiveRecord::Migration
  def up
    drop_table :promotions
    create_table :promotions do |t|
      t.timestamps
      t.string :detail,        :null => false
    end
  end

  def down
    drop_table "promotions"
    create_table :promotions do |t|
      t.string :detail
      t.boolean :bogo
      t.references :restaurant

      t.timestamps
    end
    add_index :promotions, :restaurant_id
  end
end
