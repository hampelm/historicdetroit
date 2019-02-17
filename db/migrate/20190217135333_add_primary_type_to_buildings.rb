class AddPrimaryTypeToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :primary_type, :integer
  end
end
