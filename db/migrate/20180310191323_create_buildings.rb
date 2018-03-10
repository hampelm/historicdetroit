class CreateBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :also_known_as
      t.string :byline
      t.text :description
      t.string :address
      t.string :status
      t.string :style
      t.string :year_opened
      t.string :year_closed
      t.string :year_demolished

      t.timestamps
    end
  end
end
