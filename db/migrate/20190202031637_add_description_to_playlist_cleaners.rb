class AddDescriptionToPlaylistCleaners < ActiveRecord::Migration[5.2]
  def change
    add_column :playlist_cleaners, :description, :string
  end
end
