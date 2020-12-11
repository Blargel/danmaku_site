class AddPermalinkColumns < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :permalink, :string
    add_column :projects, :permalink, :string
    add_column :versions, :permalink, :string
  end

  def self.down
    remove_column :users, :permalink
    remove_column :projects, :permalink
    remove_column :versions, :permalink
  end
end
