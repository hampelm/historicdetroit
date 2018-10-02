class AddPhotoToArchitects < ActiveRecord::Migration[5.2]
  def change
    add_column :architects, :photo, :string
  end
end
