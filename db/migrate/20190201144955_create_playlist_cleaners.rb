class CreatePlaylistCleaners < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_cleaners do |t|
      t.references :creator
      t.string :spotify_playlist_id

      t.timestamps
    end
  end
end
