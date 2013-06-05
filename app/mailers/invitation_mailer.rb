class InvitationMailer < ActionMailer::Base
  default from: ENV["MAILER_SENDER"] || "admin@culver-crosen-wedding.mailgun.org"

  def invitation_email(user)
    @user = user
    @invitations = @user.invitations
    mail(to: user.email, subject: "Invitation to the Wedding of Monica Culver and Jeremy Crosen")
  end

  # Reminder email; There are several scenarios:
  #   1) User has not confirmed their account
  #     a) Has confirmed invitations (admin entered)
  #     b) Has unconfirmed invitations
  #   2) User has confirmed invitations
  #     a) Has different guests on the invitations (possible error)
  #   3) User has unconfirmed invitations
  def invitation_reminder(user)
    @user = user
    @invitations = @user.invitations
    @user_confirmed = user.confirmed_at? ? true : false
    @unconfirmed_invitations = @invitations.select{|i| i.status_is_unconfirmed?}
    @confirmed_invitations = @invitations.select{|i| i.confirmed?}

    # Figure out if the guest lists are not identical for confirmed invitations
    @guests_differ = false
    first_guests = nil
    @confirmed_invitations.each do |i|
      if i.status_is_attending?
        first_guests = i.guests.sort if first_guests.nil?
        if first_guests.collect{|i| i.display_name } != i.guests.sort.collect{|i| i.display_name}
          puts "guest lists are different!?"
          @guests_differ = true
        end
      end
    end

    prefix = [].push(@unconfirmed_invitations ? 'Reminder' : nil).push(@confirmed_invitations ? 'Confirmation' : nil)
    mail(to: user.email, subject: "#{prefix.join('/')} for your invitation to the wedding of Monica Culver and Jeremy Crosen")
  end

  def itinerary(user)
    @user = user
    # implicit join criteria here, a little too magic...
    @attending_events = @user.events.where(invitations: {status: 'attending'}).all
    @not_attending_events = @user.events.where('invitations.status <> "attending"').all
    
    mail(to: @user.email, subject: "Your itinerary for the Monica Culver & Jeremy Crosen Wedding", from: "Monica Culver & Jeremy Crosen <admin@culver-crosen-wedding.mailgun.org>")
  end
end
