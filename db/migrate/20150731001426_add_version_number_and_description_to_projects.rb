class AddVersionNumberAndDescriptionToProjects < ActiveRecord::Migration[4.2]
  def self.up
    add_column :projects, :version_number, :string
    add_column :projects, :description, :text
  end

  def self.down
    remove_column :projects, :version_number
    remove_column :projects, :description
  end
end
