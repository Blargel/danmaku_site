class AddUnlistedToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_column :projects, :unlisted, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :unlisted
  end
end
