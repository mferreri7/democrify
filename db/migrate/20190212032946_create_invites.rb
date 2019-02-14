class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.string :user_email
      t.references :playlist_cleaner, foreign_key: true

      t.timestamps
    end
  end
end
