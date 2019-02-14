class DeleteTrackFromPlaylistJob < ApplicationJob
  queue_as :default

  def perform(user_id, spotify_user_id, spotify_playlist_id, spotify_track_id)
    user = User.find(user_id)
    @spotify_user = RSpotify::User.new(user.spotify_user_hash)
    playlist = RSpotify::Playlist.find(spotify_user_id, spotify_playlist_id)
    track = RSpotify::Track.find(spotify_track_id)
    playlist.remove_tracks!([track])
  end
end
