class AddBodyFormattedToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :body_formatted, :text
  end
end
