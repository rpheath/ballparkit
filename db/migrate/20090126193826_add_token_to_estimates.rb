class AddTokenToEstimates < ActiveRecord::Migration
  def self.up
    add_column :estimates, :token, :string
  end

  def self.down
    remove_column :estimates, :token
  end
end
