class AddBuildingIdToGalleries < ActiveRecord::Migration[5.2]
  def change
    add_column :galleries, :building_id, :integer
  end
end
