class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :party_size, :confirmed_date, :sent_date
  
  belongs_to :event, validate: true
  has_many :invitation_users, dependent: :destroy, validate: true
  has_many :users, through: :invitation_users, validate: true
  
  validates :event_id, presence: true
  
  class << self
    def with_user(user = nil)
      joins(:invitation_users).where(invitation_users: {user: user})
    end
    
    def status_list
      %w[unconfirmed unable_to_attend attending]
    end
    
    def with_role(role_name)
      joins(:invitation_users).where(invitation_users: {role: role_name})
    end
  end
  
  include Statusable  # attr_accessible :status
  include Postable # has_many :posts, as: :postable
  
  def owners
    users.where(invitation_users: {role: 'owner'}).all
  end
  
end
