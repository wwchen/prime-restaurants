class CreateYelpInfos < ActiveRecord::Migration
  def change
    create_table :yelp_infos do |t|
      t.string :id
      t.string :name
      t.string :rating_img_url
      t.integer :review_count
      t.string :mobile_url
      t.string :url
      t.string :photo_url

      t.timestamps
    end
  end
end
