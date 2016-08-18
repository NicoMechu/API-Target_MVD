class FixTargetsColumnName < ActiveRecord::Migration
  def change
    rename_column :targets, :radio, :radius
  end
end
