class Track < ApplicationRecord
  belongs_to :playlist_cleaner
  has_many :votes, dependent: :destroy
end
