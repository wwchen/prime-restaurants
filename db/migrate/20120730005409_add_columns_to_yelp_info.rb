class AddColumnsToYelpInfo < ActiveRecord::Migration
  def change
    change_table :yelp_infos do |t|
      t.column     :query_string, :string
      t.column    :is_claimed, :boolean
      t.column    :is_closed, :boolean
      t.column     :display_phone, :string
      t.column    :rating, :integer
      t.column     :rating_img_url_small, :string
      t.column     :rating_img_url_large, :string
      t.column     :snippet_text, :string
      t.string     :scolumn, :nippet_image_url
      t.column      :latitude, :float
      t.column      :longitude, :float
      t.column     :display_address, :string

      t.references :yelp_categories
    end
  end
end
