class Guest < ActiveRecord::Base
  attr_accessible :invitation_id, :user_id
  
  belongs_to :invitation
  belongs_to :user
  has_one :event, through: :invitation
  
  include Roleable # attr_accessible :role
  include Nameable # attr_accessible :first_name, :last_name, :display_name
  
  validates :invitation_id, presence: true
  validates :role, presence: true # Roleable doesn't require presence by default
  
  validate :validate_uniqueness_of_event

  # For each Nameable 
  %w[first_name last_name display_name].each do |m|
    define_method "#{m}" do
      user_id ? user.send(m) : read_attribute(m)
    end
  end
  
  private
  def validate_uniqueness_of_event
    _user_id = user_id

    # Shortcut to prevent a database hit for validity when it's not necessary
    if _user_id.nil?
      return true
    end

    _event_id = event ? event.id : nil
    _self_id = self.id || 0

    if i = Invitation.includes(:guests).where(invitations: {event_id: _event_id}).where('guests.id <> ? and guests.user_id = ?', _self_id, _user_id).first
      owners = i.owners.map {|owner| owner.display_name }
      errors.add(:uniqueness, "A user can only be on one invitation per event; #{user.display_name} is currently invited to the same event on an invitation owned by: #{owners}") unless i.nil?
    end
  end

end

