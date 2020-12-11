class BlockedIp < ApplicationRecord
  def self.include?(ip)
    self.where(:ip_address => ip).exists?
  end
end
