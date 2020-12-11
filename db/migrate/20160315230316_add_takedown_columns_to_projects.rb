class AddTakedownColumnsToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_column :projects, :soft_deleted, :boolean, :default => false
    add_column :projects, :deleted_reason, :string
  end

  def self.down
    remove_column :projects, :soft_deleted
    remove_column :projects, :deleted_reason
  end
end
