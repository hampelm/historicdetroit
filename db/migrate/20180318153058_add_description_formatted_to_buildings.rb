class AddDescriptionFormattedToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :description_formatted, :text
  end
end
