class AddHashToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :spotify_user_hash, :jsonb
  end
end
