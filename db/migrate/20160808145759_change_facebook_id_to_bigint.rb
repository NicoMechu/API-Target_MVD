class ChangeFacebookIdToBigint < ActiveRecord::Migration
  def change
    def self.up
      change_table :users do |t|
        t.change :facebook_id, :bigint
      end
    end
    def self.down
      change_table :users do |t|
        t.change :facebook_id, :string
      end
    end
  end
end
