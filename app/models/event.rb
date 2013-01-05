class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title, :is_public
  
  validates :title, presence: true
  validates :description, presence: true
  
  has_many :invitations, dependent: :destroy, validate: true
  has_many :guests, through: :invitations, validate: true
  
  include Postable # has_many :posts, as: :postable
  
  default_scope order("scheduled_date ASC")
  
  # Class methods
  class << self
    def public
      where(is_public: true)
    end
    
    def invited(user)
      joins(:guests).where(guests: {user_id: user.id})
    end
    
    def with_user(user = nil)
      if user && user.is_admin?
        Event.where('1 = 1')
      elsif user.nil?
        where(is_public: true)
      else
       includes(:guests).where("guests.user_id = ? or (guests.id is NULL and events.is_public = ?)", user ? user.id : 0, true)
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
      !guests.where(user_id: user.id).empty?
    end
  end
  
end
