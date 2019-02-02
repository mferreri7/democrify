class PagesController < ApplicationController

  def home
    @spotify_user = RSpotify::User.new(current_user.spotify_user_hash)
  end
end
