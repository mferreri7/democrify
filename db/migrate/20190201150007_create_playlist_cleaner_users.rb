class CreatePlaylistCleanerUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_cleaner_users do |t|
      t.references :user, foreign_key: true
      t.references :playlist_cleaner, foreign_key: true

      t.timestamps
    end
  end
end
