class CreateArchitects < ActiveRecord::Migration[5.2]
  def change
    create_table :architects do |t|
      t.string :name
      t.string :byline
      t.string :last_name_first
      t.string :firm
      t.text :description
      t.string :birth
      t.string :death

      t.timestamps
    end
  end
end
