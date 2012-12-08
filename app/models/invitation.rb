class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :party_size, :confirmed_date, :sent_date
  
  belongs_to :event, validate: true
  belongs_to :user, validate: true
  
  validates :event_id, presence: true
  validates :user_id, presence: true
  
  STATUS_LIST = %w[unconfirmed unable_to_attend attending]
  include Statusable  # attr_accessible :status
  include Postable # has_many :posts, as: :postable
  
end
