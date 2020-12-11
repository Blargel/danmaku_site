class AddPasswordTokenAndPasswordTokenExpirationToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :password_token, :string
    add_column :users, :password_token_expiration, :datetime
  end

  def self.down
    remove_column :users, :password_token
    remove_column :users, :password_token_expiration
  end
end
