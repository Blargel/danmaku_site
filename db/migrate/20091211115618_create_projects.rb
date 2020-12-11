class CreateProjects < ActiveRecord::Migration[4.2]
  def self.up
    create_table :projects do |t|
      t.string :title
      t.text   :description
      t.string :category
      t.string :engine
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
