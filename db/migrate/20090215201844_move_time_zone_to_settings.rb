class MoveTimeZoneToSettings < ActiveRecord::Migration
  def self.up
    remove_column :users, :time_zone
    add_column :settings, :time_zone, :string
  end

  def self.down
    add_column :users, :time_zone, :string
    remove_column :settings, :time_zone
  end
end
