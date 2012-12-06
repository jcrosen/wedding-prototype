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
      
      # User the with_viewer method to determine viewership rights
      can :read, Post do |*posts|
        t = true
        user_posts = Post.with_viewer(user)
        posts.each { |post| t = t && user_posts.include?(post) }
        t
      end
      
      # Can read and confirm an invitation associated to the user
      can :read, Invitation, :user_id => user.id
      can :confirm, Invitation, :user_id => user.id
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
    end
    
  end
  
end
