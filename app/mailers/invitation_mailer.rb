class InvitationMailer < ActionMailer::Base
  default from: ENV["MAILER_SENDER"] || "admin@crosen-culver-wedding.mailgun.org"

  def invitation_email(user)
    @user = user
    mail(to: user.email, subject: "Invitation to the Wedding of Monica Culver and Jeremy Crosen")
  end
end
