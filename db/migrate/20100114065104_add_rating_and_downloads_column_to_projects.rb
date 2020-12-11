class AddRatingAndDownloadsColumnToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_column :projects, :rating, :integer, :default => 0
    add_column :projects, :downloads, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :rating
    remove_column :projects, :downloads
  end
end
