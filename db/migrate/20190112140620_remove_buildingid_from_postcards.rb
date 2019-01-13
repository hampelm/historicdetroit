class RemoveBuildingidFromPostcards < ActiveRecord::Migration[5.2]
  def change
    remove_column :postcards, :building_id, :integer
  end
end
