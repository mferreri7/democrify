class PagesController < ApplicationController

  def home
    @spotify_user = RSpotify::User.new(current_user.spotify_user_hash)
    @playlist = RSpotify::Playlist.find("paisna1", "7qk4yceIPn0StP1pFIytlZ")
    @tracks = @playlist.tracks
  end
end
