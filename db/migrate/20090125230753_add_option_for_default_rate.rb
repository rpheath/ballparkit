class AddOptionForDefaultRate < ActiveRecord::Migration
  def self.up
    add_column :settings, :use_default_rate, :boolean, :default => true
  end

  def self.down
    remove_column :settings, :use_default_rate
  end
end
