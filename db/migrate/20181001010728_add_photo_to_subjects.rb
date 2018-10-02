class AddPhotoToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :photo, :string
  end
end
