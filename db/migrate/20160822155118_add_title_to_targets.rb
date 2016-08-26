class AddTitleToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :title, :string
  end
end
