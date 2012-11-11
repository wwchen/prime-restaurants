# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120731083244) do

  create_table "promotions", :force => true do |t|
    t.string   "detail"
    t.boolean  "bogo"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "promotions", ["restaurant_id"], :name => "index_promotions_on_restaurant_id"

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "yelp_categories", :force => true do |t|
    t.integer  "yelp_infos_id"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "yelp_categories_yelp_categories", :id => false, :force => true do |t|
    t.integer "yelp_category_id"
    t.integer "yelp_info_id"
  end

  create_table "yelp_infos", :force => true do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "rating_img_url"
    t.integer  "review_count"
    t.string   "mobile_url"
    t.string   "url"
    t.string   "image_url"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
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
