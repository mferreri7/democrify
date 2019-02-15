class AddSavedToLibraryToTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :saved_to_library, :boolean, default: false
  end
end
