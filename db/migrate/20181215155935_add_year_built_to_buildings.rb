class AddYearBuiltToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :year_built, :string
  end
end
