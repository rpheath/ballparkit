class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :nickname
      t.string :fullname
      t.string :email
      t.string :identity_url

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
