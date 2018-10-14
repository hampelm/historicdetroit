class AddPublishedToGalleries < ActiveRecord::Migration[5.2]
  def change
    add_column :galleries, :published, :boolean
  end
end
