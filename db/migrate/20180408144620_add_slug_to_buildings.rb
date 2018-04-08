class AddSlugToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :slug, :text
  end
end
