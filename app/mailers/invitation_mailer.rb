class InvitationMailer < ActionMailer::Base
  default from: ENV["MAILER_SENDER"] || "admin@culver-crosen-wedding.mailgun.org"

  def invitation_email(user)
    @user = user
    @invitations = @user.invitations
    mail(to: user.email, subject: "Invitation to the Wedding of Monica Culver and Jeremy Crosen")
  end
end
