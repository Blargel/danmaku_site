class DanmakufuVersion < ApplicationRecord
  has_many :projects

  def self.select_array
    self.all.collect do |ver|
      [ver.name, ver.id]
    end
  end

end
