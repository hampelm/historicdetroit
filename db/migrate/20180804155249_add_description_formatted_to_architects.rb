class AddDescriptionFormattedToArchitects < ActiveRecord::Migration[5.2]
  def change
    add_column :architects, :description_formatted, :text
  end
end
