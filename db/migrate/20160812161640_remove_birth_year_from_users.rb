class RemoveBirthYearFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :birth_year, :integer
  end
end
