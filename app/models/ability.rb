class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    
    if user.is_admin?
      can :manage, :all
    elsif user.persisted?
      # Can read any events to which the user is invited
      can :read, Event do |*events|
        t = true
        user_events = Event.get_events_for_user(user)
        events.each { |event| t = t && user_events.include?(event) }
        t
      end
      
      # Can read and confirm an invitation associated to the user
      can :read, Invitation, :user_id => user.id
      can :confirm, Invitation, :user_id => user.id
    else
      # Public events can be read by all users and guests
      can :read, Event, :is_public => true
      cannot :manage, Invitation
    end
    
  end
  
end
