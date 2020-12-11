class DropVersions < ActiveRecord::Migration[4.2]
  def self.up
    drop_table :versions
  end

  def self.down
    create_table :versions, :force => true do |t|
      t.integer  :project_id
      t.integer  :user_id
      t.string   :version_number
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :permalink
      t.integer  :download_count, :default => 0
    end
  end
end
