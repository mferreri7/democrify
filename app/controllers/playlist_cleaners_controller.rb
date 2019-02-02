class PlaylistCleanersController < ApplicationController
  before_action :set_data
  def index
  end

  def create
    @playlist_cleaner = PlaylistCleaner.new(playlist_cleaner_params)
    add_users_to_playlist_cleaner(params[:playlist_cleaner][:user_ids])
    @playlist_cleaner.creator = current_user
    if @playlist_cleaner.save
      flash[:notice] = "Succefully created"
      redirect_to playlist_cleaners_path
      UpdatePlaylistInfoJob.perform_now(@playlist_cleaner.id, current_user.spotify_id)
    else
      flash.now[:alert] = "Something went wrong, please try again"
      render 'index'
    end
  end

  private

  def set_data
    @spotify_user = RSpotify::User.new(current_user.spotify_user_hash)
    @user_playlists = @spotify_user.playlists
    @users = User.where.not(id: current_user.id)
    @playlist_cleaners = PlaylistCleaner.where(creator: current_user)
  end

  def playlist_cleaner_params
    params.require(:playlist_cleaner).permit(:spotify_playlist_id, :description, :user_ids)
  end

  def add_users_to_playlist_cleaner(user_ids)
    user_ids.each do |id|
      @playlist_cleaner.users << User.find(id.to_i) unless id.blank?
    end
    @playlist_cleaner.users << current_user
  end
end
