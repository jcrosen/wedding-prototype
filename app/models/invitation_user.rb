class InvitationUser < ActiveRecord::Base
  attr_accessible :invitation_id, :user_id
  
  belongs_to :invitation
  belongs_to :user
  has_one :event, through: :invitation
  
  include Roleable # attr_accessible :role
  include Nameable # attr_accessible :first_name, :last_name, :display_name; used only if there is no User associated which is also a Nameable
  
  validates :invitation_id, presence: true
  validates :role, presence: true # Roleable doesn't require presence by default
  
  validate :validate_uniqueness_of_event

  class << self
    def to_guest(_invitation_user)
      if !_invitation_user.nil?
        _nameable = _invitation_user.nameable
        g = Guests::Guest.new(user_id: _invitation_user.user_id, full_name: _nameable.full_name, 
                              first_name: _nameable.first_name, last_name: _nameable.last_name, display_name: _nameable.display_name)
      end
      
      return g
    end
  end

  def nameable
    user_id.nil? ? self : user
  end

  def guest
    InvitationUser.to_guest(self)
  end
  
  private
  def validate_uniqueness_of_event
    _event_id = event ? event.id : nil
    _user_id = user_id
    _self_id = self.id ? self.id : 0
    
    if _user_id.nil?
      return true
    elsif i = Invitation.includes(:invitation_users).where(invitations: {event_id: _event_id}).where('invitation_users.id <> ? and invitation_users.user_id = ?', _self_id, _user_id).first
      owners = i.owners.map {|owner| owner.display_name }
      errors.add(:uniqueness, "A user can only be on one invitation per event; #{user.display_name} is currently on an invitation owned by: #{owners}") unless i.nil?
    end
  end
end

