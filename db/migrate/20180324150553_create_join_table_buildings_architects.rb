class CreateJoinTableBuildingsArchitects < ActiveRecord::Migration[5.2]
  def change
    create_join_table :buildings, :architects do |t|
      # t.index [:building_id, :architect_id]
      # t.index [:architect_id, :building_id]
    end
  end
end
