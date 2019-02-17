class AddPreviousIdToPostcards < ActiveRecord::Migration[5.2]
  def change
    add_column :postcards, :previous_id, :numeric
  end
end
