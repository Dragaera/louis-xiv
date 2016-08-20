# Helper methods defined here can be accessed in any controller or view in the application

module LouisXiv
  class App
    module ApplicationHelper
      def to_bool(value)
        case value
        when 0, '0', 'false', 'off', 'no'
          false
        when 1, '1', 'true', 'on', 'yes'
          true
        else
          raise ArgumentError, "Could not convert #{ value.inspect } to boolean"
        end
      end
    end

    helpers ApplicationHelper
  end
end
