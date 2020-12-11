class AddS3KeyToAsset < ActiveRecord::Migration[4.2]
  def self.up
    add_column :assets, :s3_key, :string
  end

  def self.down
    remove_column :assets, :s3_key
  end
end
