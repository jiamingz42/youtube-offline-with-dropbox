class AddCredentialKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :credential_key, :string
  end
end
