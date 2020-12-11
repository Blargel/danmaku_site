class CreateComments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :comments do |t|
      t.integer :author_id
      t.string  :content
      t.integer :commentable_id
      t.string  :commentable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
