class ExpandAddress < ActiveRecord::Migration
  def up
    change_table :restaurants do |t|
      t.remove :address
      t.remove :telephone

      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
    end
  end

  def down
    change_table :restaurants do |t|
      t.string :address
      t.text :telephone

      t.remove :street
      t.remove :city
      t.remove :state
      t.remove :zip
      t.remove :phone
    end
  end
end
