class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :estimate_id
      t.integer :user_id
      t.string :description
      t.string :hours
      t.string :rate
      t.boolean :default

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
