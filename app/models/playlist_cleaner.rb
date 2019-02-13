class PlaylistCleaner < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :playlist_cleaner_users, dependent: :destroy
  has_many :users, through: :playlist_cleaner_users
  has_many :tracks, dependent: :destroy
  has_many :invites, dependent: :destroy

  validates :spotify_playlist_id, :description, presence: true

  def votes_required_for_democracy
    (users.size / 2).floor + 1
  end
end
