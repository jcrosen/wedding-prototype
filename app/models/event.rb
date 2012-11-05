class Event < ActiveRecord::Base
  attr_accessible :description, :location, :scheduled_date, :title
  
  has_many :invitations
end
