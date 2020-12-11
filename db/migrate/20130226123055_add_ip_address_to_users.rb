class AddIpAddressToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :ip_address, :string
  end

  def self.down
    remove_column :users, :ip_address
  end
end
