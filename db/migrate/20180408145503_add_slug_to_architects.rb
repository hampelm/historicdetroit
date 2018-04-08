class AddSlugToArchitects < ActiveRecord::Migration[5.2]
  def change
    add_column :architects, :slug, :text
  end
end
