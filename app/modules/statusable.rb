
# Module assumes it's included into an ActiveRecord object which has a string column named "status"
module Statusable
  extend ActiveSupport::Concern
  
  def Statusable.printable(_status)
    _status ? _status.gsub(/_/, ' ').titleize : nil
  end
    
  STATUS_LIST = %w[unconfirmed unable_to_attend attending]
  
  included do
    attr_accessible :status
    
    # metaprogramming that defines some simple finders on the class
    class << self
      def with_status(_status)
        where(:status => _status)
      end
      
      STATUS_LIST.each do |_status|
        # Finders
        define_method "status_#{_status}" do
          with_status(_status)
        end
      end
      
      def status_list
        STATUS_LIST
      end
    
      # Helper for RailsAdmin to determine an enumerable list for a string column
      def status_enum
        status_list
      end
      
      def printable_status_list
        status_list.map { |status| Statusable.printable(status) }
      end
    end
    
    validates :status, inclusion: { in: self.status_list, message: "%{value} is not a valid status" }
    
    # Alters a status string into a printable string for display
    def printable_status
      Statusable.printable(status)
    end
    
    # metaprogramming that defines some simple checkers on the instances
    STATUS_LIST.each do |_status|
      # Instance Checkers
      define_method "status_is_#{_status}?" do
        self.status == _status
      end
    end
  end
end