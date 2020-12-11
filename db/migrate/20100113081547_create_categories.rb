class CreateCategories < ActiveRecord::Migration[4.2]
  def self.up
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    add_column :projects, :category_id, :integer
  end

  def self.down
    drop_table :categories
    remove_column :projects, :category_id
  end
end
