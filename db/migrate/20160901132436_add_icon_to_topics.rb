class AddIconToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :icon, :string
  end
end
