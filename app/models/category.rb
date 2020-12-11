class Category < ApplicationRecord
  has_many :projects

  def self.select_array
    self.all.collect do |cat|
      [cat.name, cat.id]
    end
  end

end
