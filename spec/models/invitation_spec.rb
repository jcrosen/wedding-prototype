require 'spec_helper'

describe Invitation do
  
  it { should respond_to :event_id }
  it { should respond_to :user_id }
  it { should respond_to :status }
  it { should respond_to :confirmed_date }
  it { should respond_to :sent_date }
  it { should respond_to :party_size }
  
  it { should validate_presence_of :event_id }
  it { should validate_presence_of :user_id }
  
  it { should belong_to(:event).validate }
  it { should belong_to(:user).validate }
  
end
