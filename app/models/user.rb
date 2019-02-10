class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :created_cleaners, class_name: "PlaylistCleaner", foreign_key: "creator_id"
  has_many :playlist_cleaner_users
  has_many :playlist_cleaners, through: :playlist_cleaner_users
  has_many :votes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:spotify]

  def self.find_for_spotify_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :display_name)
    user_params[:spotify_id] = auth.info.id
    if auth.info.images.blank?
      user_params[:spotify_picture_url] = "https://res.cloudinary.com/dnf96fubu/image/upload/v1520418809/facebook-profile-picture-no-pic-avatar.jpg"
    else
      user_params[:spotify_picture_url] = auth.info.images.first.url
    end
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h
    spotify_user = RSpotify::User.new(auth)
    user_params[:spotify_user_hash] = spotify_user.to_hash
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end

    return user
  end
end

