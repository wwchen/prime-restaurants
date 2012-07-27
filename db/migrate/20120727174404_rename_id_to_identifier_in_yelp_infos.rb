class RenameIdToIdentifierInYelpInfos < ActiveRecord::Migration
  def up
    rename_column :yelp_infos, :id, :identifier
    change_column :yelp_infos, :identifier, :string
  end

  def down
    rename_column :yelp_infos, :identifier, :id
    change_column :yelp_infos, :id, :integer
  end
end
