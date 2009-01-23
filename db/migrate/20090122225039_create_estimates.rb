class CreateEstimates < ActiveRecord::Migration
  def self.up
    create_table :estimates do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :estimates
  end
end
