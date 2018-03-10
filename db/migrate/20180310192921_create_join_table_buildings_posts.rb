class CreateJoinTableBuildingsPosts < ActiveRecord::Migration[5.2]
  def change
    create_join_table :buildings, :posts do |t|
      # t.index [:building_id, :post_id]
      # t.index [:post_id, :building_id]
    end
  end
end
