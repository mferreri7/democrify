class PlaylistCleanerUser < ApplicationRecord
  belongs_to :user
  belongs_to :playlist_cleaner
end
