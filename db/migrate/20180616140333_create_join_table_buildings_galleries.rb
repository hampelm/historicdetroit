class CreateJoinTableBuildingsGalleries < ActiveRecord::Migration[5.2]
  def change
    create_join_table :galleries, :buildings do |t|
      # t.index [:gallery_id, :building_id]
      # t.index [:building_id, :gallery_id]
    end
  end
end
