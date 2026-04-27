class AddViewTypeToGalleries < ActiveRecord::Migration[5.2]
  def change
    add_column :galleries, :view_type, :integer, default: 0, null: false
  end
end
