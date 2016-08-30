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

      def pp_form_errors(form_errors)
        form_errors.map do |attr, errors|
          "#{ attr.capitalize }: #{ errors.map(&:capitalize).join(', ') }"
        end
      end

      def pp_int(int)
        int.to_s.reverse.gsub(/(\d{3})(?=\d)/, "\\1'").reverse
      end

      def pp_si(value, unit)
        if value.abs < 1_000
          "#{ value } #{ unit }"
        elsif value.abs < 1_000_000
          "#{ value / 1_000.0 } k#{ unit }"
        else
          "#{ value / 1_000_000.0 } M#{ unit }"
        end
      end

      def to_int(values, strict: true)
        out = []
        values.each do |x|
          begin
            out << Integer(x)
          rescue ArgumentError
            raise if strict
          end
        end
        out
      end
    end 

    helpers ApplicationHelper
  end
end
