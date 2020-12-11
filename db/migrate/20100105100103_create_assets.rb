class CreateAssets < ActiveRecord::Migration[4.2]
  def self.up
    create_table :assets do |t|
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at

      t.integer  :attachable_id
      t.string   :attachable_type
      t.timestamps
    end
    remove_column :versions, :script_bundle_file_name
    remove_column :versions, :script_bundle_content_type
    remove_column :versions, :script_bundle_file_size
    remove_column :versions, :script_bundle_updated_at
    add_column :versions, :asset_id, :integer
  end

  def self.down
    drop_table :assets
    add_column :versions, :script_bundle_file_name, :string
    add_column :versions, :script_bundle_content_type, :string
    add_column :versions, :script_bundle_file_size, :integer
    add_column :versions, :script_bundle_updated_at, :datetime
    remove_column :versions, :asset_id
  end
end
