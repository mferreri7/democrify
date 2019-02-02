class UpdatePlaylistInfoJob < ApplicationJob
  queue_as :default

  def perform(playlist_cleaner_id, spotify_user_id)
    playlist_cleaner = PlaylistCleaner.find(playlist_cleaner_id)
    playlist = RSpotify::Playlist.find(spotify_user_id, playlist_cleaner.spotify_playlist_id)
    return unless playlist
    playlist_info = {
      playlist_name: playlist.name,
      playlist_picture_url: playlist.images.first["url"]
    }
    playlist_cleaner.update(playlist_info)
  end
end
