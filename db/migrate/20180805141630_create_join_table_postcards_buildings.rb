class CreateJoinTablePostcardsBuildings < ActiveRecord::Migration[5.2]
  def change
    create_join_table :postcards, :buildings do |t|
      # t.index [:postcard_id, :building_id]
      # t.index [:building_id, :postcard_id]
    end
  end
end
