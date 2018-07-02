class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :body_formatted, :text
  end
end
