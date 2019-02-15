class ActOnTrackFromPlaylistJob < ApplicationJob
  queue_as :default

  def perform(args = {})
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
    user_id = args[:user_id]
    spotify_user_id = args[:spotify_user_id]
    spotify_playlist_id = args[:spotify_playlist_id]
    spotify_track_id = args[:spotify_track_id]
    category = args[:category]
    relocate_playlist_id = args[:relocate_playlist_id]

    user = User.find(user_id)
    @spotify_user = RSpotify::User.new(user.spotify_user_hash)
    relocate_playlist = RSpotify::Playlist.find(spotify_user_id, relocate_playlist_id) if category == "Relocate"
    playlist = RSpotify::Playlist.find(spotify_user_id, spotify_playlist_id)
    track = RSpotify::Track.find(spotify_track_id)
    relocate_playlist.add_tracks!([track]) if category == "Relocate"
    playlist.remove_tracks!([track])
  end
end
