class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :playlist_cleaner, foreign_key: true
      t.string :spotify_id
      t.integer :votes, default: 0

      t.timestamps
    end
  end
end
