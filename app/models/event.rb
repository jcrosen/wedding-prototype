class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title, :is_public
  
  has_many :invitations, dependent: :destroy
  
  default_scope order("scheduled_date ASC")
  
  class << self
    def public
      where(is_public: true)
    end
    
    def invited(user)
      joins(:invitations).where(:invitations => {:user_id => user.id})
    end
    
    def get_events_for_user(user = nil)
      if user && user.is_admin?
        Event.where('1 = 1')
      else
        includes(:invitations).where("invitations.user_id = ? or is_public = ?", user ? user.id : 0, true)
      end
    end
  end
  
end
