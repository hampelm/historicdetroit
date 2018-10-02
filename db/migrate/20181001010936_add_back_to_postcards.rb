class AddBackToPostcards < ActiveRecord::Migration[5.2]
  def change
    add_column :postcards, :back, :string
  end
end
