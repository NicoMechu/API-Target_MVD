class AddTargetsAndVisibilitieToMatches < ActiveRecord::Migration
  def change
    add_column :match_conversations, :target_a_id,  :integer
    add_column :match_conversations, :target_b_id,  :integer
    add_column :match_conversations, :visible_a,    :boolean, default: true
    add_column :match_conversations, :visible_b,    :boolean, default: true
  end
end
