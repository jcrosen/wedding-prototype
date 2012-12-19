class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :party_size, :confirmed_at, :sent_at
  
  belongs_to :event, validate: true
  has_many :invitation_users, dependent: :destroy, validate: true
  has_many :users, through: :invitation_users, validate: true
  
  validates :event_id, presence: true
  
  class << self
    def with_user(user = nil)
      if user && user.is_admin?
        Invitation.where('1 = 1')
      else
        _user_id = user ? user.id : 0
        joins(:users).where(users: {id: _user_id})
      end
    end
    
    def with_role(role)
      joins(:invitation_users).where(invitation_users: {role: role})
    end
    
    # Override for the list of available status values
    def status_list
      %w[unconfirmed unable_to_attend attending]
    end
  end
  
  include Statusable  # attr_accessible :status
  include Postable # has_many :posts, as: :postable
  
  def owners
    users.where(invitation_users: {role: 'owner'}).all
  end
  
  def confirm(args = {})
    if !args or args.empty?
      return nil
    end
    
    self.status = args[:status].to_s
    
    if _valid = self.valid?
      self.confirmed_at = Time.now
    end
    
    return _valid
  end
  
  def confirm!(args = {})
    confirm(args)
    self.save
  end
  
  def reset_confirmation
    self.status = "unconfirmed"
    self.confirmed_at = nil
  end
  
  def reset_confirmation!
    reset_confirmation
    self.save
  end
  
  def confirmed?
    !status_is_unconfirmed? && !confirmed_at.nil?
  end
  
  def send_invitation
    _sent = false
    
    invitation_users.each do |iu|
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!! Sending Invitation for Event:#{event.title} and Users:#{iu.user.display_name}=>#{iu.role} at #{iu.user.email}\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      
    end
    
    sent_at = Time.now unless !_sent
    
    _sent
  end
  
  def clear_status
    status = :unconfirmed
    sent_at = nil
  end
  
end
