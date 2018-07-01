class ChangeSlugToString < ActiveRecord::Migration[5.2]
  def change
    change_column :architects, :slug, :string
    change_column :buildings, :slug, :string
    change_column :galleries, :slug, :string
  end
end
