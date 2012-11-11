class CreateYelpCategories < ActiveRecord::Migration
  def change
    create_table :yelp_categories_yelp_categories, :id => false do |t|
      t.integer :yelp_category_id
      t.integer :yelp_info_id
    end
    create_table :yelp_categories do |t|
      t.references :yelp_infos
      t.string     :name
      t.timestamps
    end
  end
end
