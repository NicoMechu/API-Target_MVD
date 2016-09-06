class FixUserNameMatcheConverstations < ActiveRecord::Migration
  def change
    rename_column :match_conversations, :user_A_id, :user_a_id
    rename_column :match_conversations, :user_B_id, :user_b_id
  end
end
