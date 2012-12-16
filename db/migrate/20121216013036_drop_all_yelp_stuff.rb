# Reverting old crap. Not sure what I'm doing before.
# I see a lot of mistakes of typos and autogenerations.

class DropAllYelpStuff < ActiveRecord::Migration
  def up
    drop_table "yelp_categories"
    drop_table "yelp_categories_yelp_categories"
    drop_table "yelp_infos"
  end

  def down
    # Copying from schema.db.. Is it the current state of things?
    create_table "yelp_categories", :force => true do |t|
      t.timestamps
      t.integer  "yelp_infos_id"
      t.string   "name"
      t.string   "display_name"
    end

    create_table "yelp_categories_yelp_categories", :id => false, :force => true do |t|
      t.integer "yelp_category_id"
      t.integer "yelp_info_id"
    end

    create_table "yelp_infos", :force => true do |t|
      t.timestamps
      t.string   "identifier"
      t.string   "name"
      t.string   "rating_img_url"
      t.integer  "review_count"
      t.string   "mobile_url"
      t.string   "url"
      t.string   "image_url"
      t.integer  "restaurant_id"
      t.string   "query_string"
      t.boolean  "is_claimed"
      t.boolean  "is_closed"
      t.string   "display_phone"
      t.integer  "rating"
      t.string   "rating_img_url_small"
      t.string   "rating_img_url_large"
      t.string   "snippet_text"
      t.string   "scolumn"
      t.string   "nippet_image_url"
      t.float    "latitude"
      t.float    "longitude"
      t.string   "display_address"
      t.integer  "yelp_categories_id"
    end
  end
end
