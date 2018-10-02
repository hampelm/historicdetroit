class AddFrontToPostcards < ActiveRecord::Migration[5.2]
  def change
    add_column :postcards, :front, :string
  end
end
