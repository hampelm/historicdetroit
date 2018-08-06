class CreatePostcards < ActiveRecord::Migration[5.2]
  def change
    create_table :postcards do |t|
      t.string :title
      t.text :caption
      t.string :byline
      t.string :subject
      t.references :building, foreign_key: true

      t.timestamps
    end
  end
end
