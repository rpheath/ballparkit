class CreateDefaultTasks < ActiveRecord::Migration
  def self.up
    create_table :default_tasks do |t|
      t.integer :setting_id
      t.string :description
      t.timestamps
    end
    
    remove_column :tasks, :default
  end

  def self.down
    drop_table :default_tasks
    add_column :tasks, :default, :boolean
  end
end
