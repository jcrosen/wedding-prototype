
# Roles module assumes that here is a string attribute available as :role that describes the current role of the object
# It also expects that you have set a ROLE_LIST constant in your object; if it has not been set it will default to the list specified below
module Roleable
  extend ActiveSupport::Concern
  
  def Roleable.printable(_role)
    _role ? _role.gsub(/_/, ' ').titleize : nil
  end
  
  # To override, decleare a status_list method on your including object
  def Roleable.default_role_list
    %w[owner contributor reader]
  end
    
  included do
    attr_accessible :role
    
    # If the including class doesn't define a default status list then we'll do so here using the Statusable module's status list
    if !defined? role_list
      def self.role_list
        Roleable.default_role_list
      end
    end

    # metaprogramming that defines some simple finders on the class
    class << self
      def with_role(role_name)
        where(:role => role_name.to_s)
      end
      
      def role_enum
        role_list
      end
    end
    
    role_list.each do |role_name|
      # Setters
      define_method "set_role_as_#{role_name}!" do
        role_will_change!
        self.role = role_name
        if self.role == role_name
          return role_name
        else
          return nil
        end
      end
      # Instance Checkers
      define_method "is_#{role_name}?" do
        self.role == role_name
      end
    end
  end
end