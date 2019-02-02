class DropVotesOnTracks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tracks, :votes
  end
end
