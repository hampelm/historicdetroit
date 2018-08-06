class CreateJoinTablePostcardsSubjects < ActiveRecord::Migration[5.2]
  def change
    create_join_table :postcards, :subjects do |t|
      # t.index [:postcard_id, :subject_id]
      # t.index [:subject_id, :postcard_id]
    end
  end
end
