class RemoveChannelIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :channel_id, :string
  end
end
