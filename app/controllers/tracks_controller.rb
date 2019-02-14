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
    delete_track_from_playlist
  end

  private

  def set_track
    @playlist_cleaner = PlaylistCleaner.find(params[:playlist_cleaner_id])
    @track = Track.where(playlist_cleaner: @playlist_cleaner).find_by(spotify_id: params[:id])
    @votes = @track.votes
    @keep_votes = @votes.where(category: "Relocate").joins(:user).pluck("spotify_playlist_name, users.spotify_picture_url, users.display_name").group_by { |i| i[0] }
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

  def delete_track_from_playlist
    required_votes = @playlist_cleaner.votes_required_for_democracy
    track_votes_for_category = @track.votes.where(category: "Delete").size
    DeleteTrackFromPlaylistJob.set(wait: 1.minute).perform_later(
      current_user.id,
      @playlist_cleaner.creator.spotify_id,
      @playlist_cleaner.spotify_playlist_id,
      @track.spotify_id
    ) if track_votes_for_category >= required_votes
  end
end
