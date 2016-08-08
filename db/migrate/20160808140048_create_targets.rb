class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.integer :user_id
      t.integer :topic_id
      t.float :lat
      t.float :lng
      t.integer :radio

      t.timestamps null: false
    end
  end
end
