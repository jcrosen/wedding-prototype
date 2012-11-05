class Invitation < ActiveRecord::Base
  attr_accessible :display_name, :email, :event_id, :party_size, :respond_date, :sent_date, :status, :user_id
  
  has_one :event
  
end
