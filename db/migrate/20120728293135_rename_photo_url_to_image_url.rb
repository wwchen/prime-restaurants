class RenamePhotoUrlToImageUrl < ActiveRecord::Migration
  def up
    rename_column :yelp_infos, :photo_url, :image_url
  end

  def down
    rename_column :yelp_infos, :image_url, :photo_url
  end
end
