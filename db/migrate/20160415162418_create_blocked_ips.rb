class CreateBlockedIps < ActiveRecord::Migration[4.2]
  def self.up
    create_table :blocked_ips do |t|
      t.string :ip_address
      t.timestamps
    end
  end

  def self.down
    drop_table :blocked_ips
  end
end
