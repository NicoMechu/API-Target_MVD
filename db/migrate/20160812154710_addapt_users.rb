class AddaptUsers < ActiveRecord::Migration
  def change
    remove_column :users, :last_name,   :string
    remove_column :users, :first_name,  :string
    remove_column :users, :username,    :string  
    add_column    :users, :gender,      :integer
    add_column    :users, :name,        :string
  end
end
