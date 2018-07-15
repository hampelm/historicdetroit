class AddLatLngToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :lat, :decimal
    add_column :buildings, :lng, :decimal
  end
end
