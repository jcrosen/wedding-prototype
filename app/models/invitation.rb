class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :party_size, :confirmed_date, :sent_date, :status
  
  belongs_to :event, validate: true
  belongs_to :user, validate: true
  
  validates :event_id, presence: true
  validates :user_id, presence: true
  
end
