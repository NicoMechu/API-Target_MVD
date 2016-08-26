class CreateMatchConversations < ActiveRecord::Migration
  def change
    create_table :match_conversations do |t|
      t.integer :topic_id
      t.integer :user_A_id
      t.integer :user_B_id

      t.timestamps null: false
    end
  end
end
