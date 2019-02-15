class TracksController < ApplicationController
  before_action :set_track

  def show
    render layout: false
    # render json: @track, include: :votes
  end

  def vote_move
    register_vote("Relocate")
    act_on_track_from_playlist?("Relocate")
  end

  def vote_delete
    register_vote("Delete")
    act_on_track_from_playlist?("Delete")
  end

  def save_to_library
    @spotify_user = RSpotify::User.new(current_user.spotify_user_hash)
    track = RSpotify::Track.find(@track.spotify_id)
    @spotify_user.save_tracks!([track])
    @track.update(saved_to_library: true)
  end

  private

  def set_track
    @playlist_cleaner = PlaylistCleaner.find(params[:playlist_cleaner_id])
    @track = Track.where(playlist_cleaner: @playlist_cleaner).find_by(spotify_id: params[:id])
    @votes = @track.votes
    @keep_votes = @votes.where(category: "Relocate").joins(:user).pluck("spotify_playlist_name, users.spotify_picture_url, users.display_name").group_by { |i| i[0] }
    @delete_votes = @votes.where(category: "Delete")
    @required_votes = @playlist_cleaner.votes_required_for_democracy
    @delete_won = @track.votes.where(category: "Delete").size >= @required_votes
    @relocate_won = @votes.where(category: "Relocate").group(:spotify_playlist_name, :spotify_playlist_id).count.any? { |_k, v| v >= @required_votes }
  end

  def vote_params
    params.permit(:spotify_playlist_id, :spotify_playlist_name)
  end

  def register_vote(category)
    @vote = Vote.new(vote_params)
    @vote.user = current_user
    @vote.category = category
    @track.votes << @vote
  end

  def act_on_track_from_playlist?(category)
    if category == "Delete"
      act_on_track = @track.votes.where(category: "Delete").size >= @required_votes
    elsif category == "Relocate"
      track_relocate_votes = @votes.where(category: "Relocate").group(:spotify_playlist_name, :spotify_playlist_id).count
      act_on_track = track_relocate_votes.any? { |_k, v| v >= @required_votes }
      winner_playlist_to_relocate = track_relocate_votes.keep_if { |_k, v| v >= @required_votes } if act_on_track
    end
    ActOnTrackFromPlaylistJob.set(wait_until: Date.tomorrow.midnight).perform_later(
      user_id: current_user.id,
      spotify_user_id: @playlist_cleaner.creator.spotify_id,
      spotify_playlist_id: @playlist_cleaner.spotify_playlist_id,
      spotify_track_id: @track.spotify_id,
      category: category,
      relocate_playlist_id: category == "Relocate" ? winner_playlist_to_relocate.keys.flatten[1] : nil
    ) if act_on_track
  end
end
