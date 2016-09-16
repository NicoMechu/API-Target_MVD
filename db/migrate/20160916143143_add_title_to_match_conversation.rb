class AddTitleToMatchConversation < ActiveRecord::Migration
  def change
    add_column :match_conversations, :title_a, :string
    add_column :match_conversations, :title_b, :string
  end
end
