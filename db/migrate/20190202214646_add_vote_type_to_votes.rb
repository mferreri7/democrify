class AddVoteTypeToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :category, :string
  end
end
