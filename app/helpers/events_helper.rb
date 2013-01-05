module EventsHelper
  def confirmable?(*invitations)
    current_user && current_user.can?(:confirm, *invitations)
  end
end
