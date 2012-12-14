class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title, :is_public
  
  validates :title, presence: true
  validates :description, presence: true
  
  has_many :invitations, dependent: :destroy, validate: true
  has_many :invitation_users, through: :invitations, validate: true
  
  include Postable # has_many :posts, as: :postable
  
  default_scope order("scheduled_date ASC")
  
  # Class methods
  class << self
    def public
      where(is_public: true)
    end
    
    def invited(user)
      joins(:invitation_users).where(invitation_users: {user_id: user.id})
    end
    
    def with_user(user = nil)
      if user && user.is_admin?
        Event.where('1 = 1')
      elsif user.nil?
        where(is_public: true)
      else
       includes(:invitation_users).where("invitation_users.user_id = ? or (invitation_users.id is NULL and events.is_public = ?)", user ? user.id : 0, true)
      end
    end
  end
  
  def posts_viewable?(user = nil)
    # TODO: Should we use the with_user class method here instead of somewhat duplicating the logic? 
    # This should be faster than using the class method, especially if this method is called over an iteration
    if is_public || (user && user.is_admin?)
      true
    elsif user.nil?
      false
    else
      !invitation_users.where(user_id: user.id).empty?
    end
  end
  
end
