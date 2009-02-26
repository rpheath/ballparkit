class AddDiscountToEstimates < ActiveRecord::Migration
  def self.up
    add_column :estimates, :discount, :string
  end

  def self.down
    remove_column :estimates, :discount
  end
end
