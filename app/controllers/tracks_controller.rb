class TracksController < ApplicationController
  def show
    @playlist_cleaner = PlaylistCleaner.find(params[:playlist_cleaner_id])
    @track = Track.where(playlist_cleaner: @playlist_cleaner).find_by(spotify_id: params[:id])
    render json: @track, include: :votes
  end

  def vote_move
    raise
  end

  def vote_delete
  end
end
