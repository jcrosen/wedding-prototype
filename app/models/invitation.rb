class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :max_party_size, :confirmed_at, :sent_at
  
  belongs_to :event, validate: true
  has_many :guests, dependent: :destroy, validate: true
  has_many :users, through: :guests, validate: true
  
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
      joins(:guests).where(guests: {role: role})
    end

    def with_event(event)
      where(event_id: event.id) unless event.nil?
    end
    
    # Override for the list of available status values
    def status_list
      %w[unconfirmed unable_to_attend attending]
    end
  end
  
  include Statusable  # attr_accessible :status
  include Postable # has_many :posts, as: :postable
  
  # People getters
  def owners
    users.where(guests: {role: 'owner'}).all
  end
  
  def confirm(args = {})
    if !args or args.empty?
      return nil
    end
    
    self.status = args[:status].to_s # to_s call allows either a string or symbol to be passed in as a status value
    
    if _valid = self.valid?
      self.confirmed_at = Time.now
    end
    
    return _valid
  end
  
  def confirm!(args = {})
    valid = confirm(args)
    self.save && valid
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
    
    guests.each do |iu|
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
