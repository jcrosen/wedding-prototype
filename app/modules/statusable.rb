
# Module assumes it's included into an ActiveRecord object which has a string column named "status"
module Statusable
  extend ActiveSupport::Concern
  
  def Statusable.printable(_status)
    _status ? _status.gsub(/_/, ' ').titleize : nil
  end
  
  # To override, decleare a status_list method on your including object
  def Statusable.default_status_list
    %w[incomplete in_progress complete]
  end
    
  included do
    attr_accessible :status
    
    # If the including class doesn't define a default status list then we'll do so here using the Statusable module's status list
    if !defined? status_list
      def self.status_list
        Statusable.default_status_list
      end
    end    
    
    # metaprogramming that defines some simple finders on the class
    class << self
      def with_status(_status)
        where(:status => _status)
      end
      
      # Helper for RailsAdmin to determine an enumerable list for a string column
      def status_enum
        status_list
      end
      
      def printable_status_list
        status_list.map { |_status| Statusable.printable(_status) }
      end
    end
    
    # metaprogramming that defines some simple checkers and finders on the instances
    status_list.each do |_status|
      # Instance Checkers
      define_method "status_is_#{_status}?" do
        status == _status
      end
    end
    
    def status=(value)
      write_attribute(:status, value.to_s)
    end
    
    validates :status, inclusion: { in: self.status_list, message: "%{value} is not a valid status" }
    
    # Alters a status string into a printable string for display
    def printable_status
      Statusable.printable(status)
    end
  end
end