class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :track, foreign_key: true
      t.string :spotify_playlist_id
      t.string :spotify_playlist_name

      t.timestamps
    end
  end
end
