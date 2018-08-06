class AddSlugToPostcards < ActiveRecord::Migration[5.2]
  def change
    add_column :postcards, :slug, :string
  end
end
