class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  # Delegate the can? and cannot? calls to the ability method
  delegate :can?, :cannot?, :to => :ability

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :inactive_at, :display_name
  attr_protected :is_admin
  
  has_many :invitations
  has_many :events, through: :invitations
  
  def ability
    @ability ||= Ability.new(self)
  end
  
  def make_admin
    self.is_admin = true
  end
  
  def is_admin?
    self.is_admin == true
  end
  
end
