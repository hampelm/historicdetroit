class AddLastUpdateToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :last_update, :datetime
  end
end
