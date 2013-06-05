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
        user_events = Event.with_user(user)
        events.each { |event| t = t && user_events.include?(event) }
        t
      end
      
      # Can read posts if the user has viewing rights (with_viewer method)
      can :read, Post do |*posts|
        t = true
        user_posts = Post.with_viewer(user)
        posts.each { |post| t = t && user_posts.include?(post) }
        t
      end
      
      # Can read an invitation associated to the user
      can :read, Invitation do |*invitations|
        t = true
        invitations.each { |i| t = t && i.users.include?(user)}
        t
      end

      # Can confirm if the current user is an owner
      can :confirm, Invitation do |*invitations|
        # Turning off confirmations
        t = false
        invitations.each { |i| t = t && i.owners.include?(user)}
        t
      end

      # Can read guests if the user is associated to those guests' invitation(s)
      can :read, Guest do |*guests|
        t = true
        guests.each { |g| t = t && g.invitation && g.invitation.users.include?(user) }
        t
      end

      # Can create new guests if the user owns the associated invitation
      can :manage, Guest do |*guests|
        t = false
        guests.each { |g| t = t && g.invitation && g.invitation.owners.include?(user) }
        t
      end

    else
      # Public events can be read by all users and guests
      can :read, Event, :is_public => true
      
      # Posts that associate to a nil user can be read by guests
      can :read, Post do |*posts|
        t = true
        user_posts = Post.with_viewer
        posts.each { |post| t = t && user_posts.include?(post) }
        t
      end
      
      cannot :manage, Invitation
      cannot :manage, Guest
    end
    
  end
  
end
