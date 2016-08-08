class AddBirthYearToUser < ActiveRecord::Migration
  def change
    add_column :users, :birth_year, :integer
  end
end
