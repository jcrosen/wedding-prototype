class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title, :is_public
  
  validates :title, presence: true
  validates :description, presence: true
  
  has_many :invitations, dependent: :destroy, validate: true
  has_many :users, through: :invitations, validate: true
  
  include Postable
  
  default_scope order("scheduled_date ASC")
  
  class << self
    def public
      where(is_public: true)
    end
    
    def invited(user)
      joins(:invitations).where(:invitations => {:user_id => user.id})
    end
    
    def with_user(user = nil)
      if user && user.is_admin?
        Event.where('1 = 1')
      else
        includes(:invitations).where("invitations.user_id = ? or is_public = ?", user ? user.id : 0, true)
      end
    end
  end
  
end
