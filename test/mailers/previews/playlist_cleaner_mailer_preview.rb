# Preview all emails at http://localhost:3000/rails/mailers/playlist_cleaner_mailer
class PlaylistCleanerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/playlist_cleaner_mailer/invite
  def invite
    PlaylistCleanerMailer.invite
  end

end
