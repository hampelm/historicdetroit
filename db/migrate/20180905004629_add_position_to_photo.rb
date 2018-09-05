class AddPositionToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :position, :integer
  end
end
