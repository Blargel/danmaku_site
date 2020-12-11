class ChangeRatingToTwoColumnsInProjects < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :projects, :rating
    add_column :projects, :win_votes, :integer, :default => 0
    add_column :projects, :fail_votes, :integer, :default => 0
  end

  def self.down
    add_column :projects, :rating, :integer, :default => 0
    remove_column :projects, :win_votes
    remove_column :projects, :fail_votes
  end
end
