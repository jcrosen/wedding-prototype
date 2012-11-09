class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :party_size, :respond_date, :sent_date, :status, :user_id
  
  belongs_to :event
  belongs_to :user
  
end
