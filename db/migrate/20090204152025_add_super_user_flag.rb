class AddSuperUserFlag < ActiveRecord::Migration
  def self.up
    add_column :users, :super_user, :boolean, :default => false
  end

  def self.down
    remove_column :users, :super_user
  end
end
