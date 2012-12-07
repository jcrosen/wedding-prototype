
# Module assumes it's included into an ActiveRecord object which has a string column named "status"
module Status
  extend ActiveSupport::Concern
  
  def Status.printable(_status)
    _status ? _status.gsub(/_/, ' ').titleize : nil
  end
  
  # Default status list if none is already specified
  STATUS_LIST ||= %w[incomplete in_progress complete]
  
  included do
    # metaprogramming that defines some simple finders on the class
    class << self
      attr_accessor :status
      
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
      
      def printable_status_list
        status_list.map { |status| Status.printable(status) }
      end
    end
    
    validates :status, inclusion: { in: STATUS_LIST, message: "%{value} is not a valid status" }
    
    # Alters a status string into a printable string for display
    def printable_status
      Status.printable(status)
    end
  
  end
  
  # metaprogramming that defines some simple checkers on the instances
  STATUS_LIST.each do |_status|
    # Instance Checkers
    define_method "status_is_#{_status}?" do
      self.status == _status
    end
  end

end