class TracksController < ApplicationController
  before_action :set_track

  def show
    render layout: false
    # render json: @track, include: :votes
  end

  def vote_move
    register_vote("Relocate")
  end

  def vote_delete
    register_vote("Delete")
  end

  private

  def set_track
    @playlist_cleaner = PlaylistCleaner.find(params[:playlist_cleaner_id])
    @track = Track.where(playlist_cleaner: @playlist_cleaner).find_by(spotify_id: params[:id])
    @votes = @track.votes
    @keep_votes = @votes.where(category: "Relocate").joins(:user).pluck("spotify_playlist_name, users.spotify_picture_url").group_by { |i| i[0] }
    @delete_votes = @votes.where(category: "Delete")
  end

  def vote_params
    params.permit(:spotify_playlist_id, :spotify_playlist_name)
  end

  def register_vote(category)
    vote = Vote.new(vote_params)
    vote.user = current_user
    vote.category = category
    @track.votes << vote
  end
end
