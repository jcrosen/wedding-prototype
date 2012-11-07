class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    
    if user.is_admin?
      can :manage, :all
    else
      # Can read any events to which the user is invited
      can :read, Event do |event|
        Event.invited(user).include?(event)
      end
      
      # Can read and confirm an invitation associated to the user
      can :read, Invitation, :user_id => user.id
      can :confirm, Invitation, :user_id => user.id
    end
    
    # Public events can be read by all users and guests
    can :read, Event, :is_public => true
    
  end
  
end
