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

ActiveRecord::Schema.define(:version => 20121216065327) do

  create_table "promotions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "detail",     :null => false
  end

  create_table "promotions_restaurants", :id => false, :force => true do |t|
    t.integer "promotion_id"
    t.integer "restaurant_id"
  end

  add_index "promotions_restaurants", ["promotion_id", "restaurant_id"], :name => "index_promotions_restaurants_on_promotion_id_and_restaurant_id"
  add_index "promotions_restaurants", ["restaurant_id", "promotion_id"], :name => "index_promotions_restaurants_on_restaurant_id_and_promotion_id"

  create_table "restaurants", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.float    "lat"
    t.float    "lng"
  end

end
