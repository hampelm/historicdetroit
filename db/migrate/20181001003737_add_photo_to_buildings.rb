class AddPhotoToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :photo, :string
  end
end
