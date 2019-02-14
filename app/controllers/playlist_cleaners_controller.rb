class PlaylistCleanersController < ApplicationController
  before_action :set_spotify_user
  before_action :set_data, only: %w[index create]
  before_action :set_playlist, :check_if_user_of_current_playlist, only: %w[show]

  def index
  end

  def show
  end

  def create
    @playlist_cleaner = PlaylistCleaner.new(playlist_cleaner_params)
    @playlist_cleaner.creator = current_user
    if @playlist_cleaner.save
      add_users_to_playlist_cleaner(params[:playlist_cleaner][:user_ids])
      flash[:notice] = "Succefully created"
      redirect_to playlist_cleaners_path
      UpdatePlaylistInfoJob.perform_later(@playlist_cleaner.id, current_user.spotify_id)
    else
      flash.now[:alert] = "Something went wrong, please try again"
      render 'index'
    end
  end

  private

  def set_spotify_user
    @spotify_user = RSpotify::User.new(current_user.spotify_user_hash)
    @user_playlists = @spotify_user.playlists
    @user_colaborative_playlists = @user_playlists.keep_if(&:collaborative)
  end

  def set_data
    @users = User.where.not(id: current_user.id)
    @created_playlist_cleaners = current_user.created_cleaners
    @shared_playlist_cleaners = current_user.playlist_cleaners.where.not(creator: current_user)
  end

  def set_playlist
    @playlist_cleaner = PlaylistCleaner.find(params[:id])
    @playlist = RSpotify::Playlist.find(@playlist_cleaner.creator.spotify_id, @playlist_cleaner.spotify_playlist_id)
    @tracks = @playlist.tracks(limit: 30, offset: params[:offset].to_i, market: @spotify_user.country)
    @tracks_from_db = Track.where(playlist_cleaner: @playlist_cleaner).map(&:spotify_id)
    @tracks.each do |track|
      track_exists = @tracks_from_db.include? track.id
      Track.create(playlist_cleaner: @playlist_cleaner, spotify_id: track.id) unless track_exists
    end
    @user_votes = current_user.votes.joins(:track).where(tracks: { playlist_cleaner: @playlist_cleaner }).map { |vote| vote.track.spotify_id }
  end

  def playlist_cleaner_params
    params.require(:playlist_cleaner).permit(:spotify_playlist_id, :description, :user_ids)
  end

  def add_users_to_playlist_cleaner(user_emails)
    user_emails.each do |email|
      user = User.find_by(email: email)
      if user
        @playlist_cleaner.users << user unless email.blank?
      else
        @playlist_cleaner.invites << Invite.new(user_email: email) unless email.blank?
      end
        PlaylistCleanerMailer.invite(email, current_user, @playlist_cleaner).deliver_now unless email.blank?
    end
    @playlist_cleaner.users << current_user
  end

  def check_if_user_of_current_playlist
    redirect_to root_path, alert: "Sorry! you don't have access to this cleaner" unless @playlist_cleaner.users.include? current_user
  end
end
