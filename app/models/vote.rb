class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :category, presence: true
end
