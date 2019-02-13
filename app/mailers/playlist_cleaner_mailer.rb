class PlaylistCleanerMailer < ApplicationMailer
  def invite(email, user, playlist_cleaner)
    @playlist_cleaner = playlist_cleaner
    @user = user
    @email = email
    mail(to: @email, subject: "#{@user.display_name} invite you to a democrify playlist cleaner")
  end
end
