class AddUseAsFilterToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :use_as_filter, :boolean
  end
end
