class CreateJoinTableBuildingsSubjects < ActiveRecord::Migration[5.2]
  def change
    create_join_table :buildings, :subjects do |t|
      # t.index [:building_id, :subject_id]
      # t.index [:subject_id, :building_id]
    end
  end
end
