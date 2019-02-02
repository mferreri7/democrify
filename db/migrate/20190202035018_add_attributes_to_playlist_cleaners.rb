class AddAttributesToPlaylistCleaners < ActiveRecord::Migration[5.2]
  def change
    add_column :playlist_cleaners, :playlist_name, :string
    add_column :playlist_cleaners, :playlist_picture_url, :string
  end
end
