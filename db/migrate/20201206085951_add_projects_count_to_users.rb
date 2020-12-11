class AddProjectsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :projects_count, :integer
  end
end
