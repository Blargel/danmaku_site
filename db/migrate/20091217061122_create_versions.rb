class CreateVersions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :versions do |t|
      t.integer  :project_id
      t.integer  :user_id
      t.string   :version_number
      t.text     :description

      t.string   :script_bundle_file_name
      t.string   :script_bundle_content_type
      t.integer  :script_bundle_file_size
      t.datetime :script_bundle_updated_at
      
      t.timestamps
    end
    remove_column :projects, :description
  end

  def self.down
    drop_table :versions
    add_column :projects, :description, :text
  end
end
