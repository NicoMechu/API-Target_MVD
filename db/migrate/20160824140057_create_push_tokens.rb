class CreatePushTokens < ActiveRecord::Migration
  def change
    create_table :push_tokens do |t|
      t.integer :user_id
      t.string :push_token

      t.timestamps null: false
    end
  end
end
