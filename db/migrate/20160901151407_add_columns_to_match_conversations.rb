class AddColumnsToMatchConversations < ActiveRecord::Migration
  def change
    add_column :match_conversations, :channel_id, :string
    add_column :match_conversations, :last_logout_a, :datetime
    add_column :match_conversations, :last_logout_b, :datetime
  end
end
