class PopulateProjectsCount < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :projects)
    end
  end
end
