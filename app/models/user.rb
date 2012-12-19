class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  # Delegate the can? and cannot? calls to the ability method
  delegate :can?, :cannot?, :to => :ability

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :inactive_at, :display_name
  attr_protected :is_admin
  
  has_many :invitation_users
  has_many :invitations, through: :invitation_users
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
  
  # Overwrite the password_required so users can be added without passwords
  def password_required?
    super if confirmed?
  end
  # Provide a simple password and confirmation matcher
  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
  
end
