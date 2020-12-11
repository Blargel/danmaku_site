class CreateDanmakufuVersions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :danmakufu_versions do |t|
      t.string   :name
      t.timestamps
    end
  end

  def self.down
    drop_table :danmakufu_versions
  end
end
