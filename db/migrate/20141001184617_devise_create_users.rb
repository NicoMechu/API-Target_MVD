# encoding: utf-8

class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: true,  default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.string   :authentication_token,   default: ""

      ## User attributes
      t.string   :first_name,             default: ""
      t.string   :last_name,              default: ""
      t.string   :username,               default: ""
      t.string   :facebook_id,            default: ""

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :authentication_token, unique: true
    add_index :users, :username,             unique: false
    add_index :users, :facebook_id,          unique: false
  end
end
