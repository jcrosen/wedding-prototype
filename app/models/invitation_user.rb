class InvitationUser < ActiveRecord::Base
  attr_accessible :invitation_id, :user_id
  
  belongs_to :invitation
  belongs_to :user
  has_one :event, through: :invitation
  
  include Roleable # attr_accessible :role
  
  validates :invitation_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true # Roleable doesn't require presence by default
  
  validate :validate_uniqueness_of_event
  
  private
  def validate_uniqueness_of_event
    _event_id = event ? event.id : nil
    _user_id = user_id
    _self_id = self.id ? self.id : 0
    
    if i = Invitation.includes(:invitation_users).where(invitations: {event_id: _event_id}).where('invitation_users.id <> ? and invitation_users.user_id = ?', _self_id, _user_id).first
      owners = i.owners.map {|owner| owner.display_name }
      errors.add(:uniqueness, "A user can only be on one invitation per event; #{user.display_name} is currently on an invitation owned by: #{owners}") unless i.nil?
    end
  end
end
