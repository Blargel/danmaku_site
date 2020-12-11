class AddDownloadCounterToVersions < ActiveRecord::Migration[4.2]
  def self.up
    add_column :versions, :download_count, :integer, :default => 0
  end

  def self.down
    remove_column :versions, :download_count
  end
end
