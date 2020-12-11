class RemoveComments < ActiveRecord::Migration[4.2]
  def self.up
    drop_table :comments
  end

  def self.down
    create_table :comments do |t|
      t.integer :author_id
      t.string  :content
      t.integer :commentable_id
      t.string  :commentable_type
      t.timestamps
    end
  end
end
