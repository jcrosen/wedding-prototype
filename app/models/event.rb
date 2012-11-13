class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title, :is_public
  
  has_many :invitations, dependent: :destroy
  
  default_scope order("scheduled_date ASC")
  
  class << self
    def public
      where(is_public: true)
    end
    def invited(user)
      joins(:invitations).where(:invitations => {:user_id => user.id}).all
    end
  end
  
end
