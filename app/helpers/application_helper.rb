module LouisXiv
  class App
    module ApplicationHelper
      SI_PREFIXES = {
        10**3  => 'k',
        10**6  => 'M',
        10**9  => 'G',
        10**12 => 'T',
        10**15 => 'P',
      }

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

      def pp_si(value, unit, round: 2)
        return '' if value.nil?

        SI_PREFIXES.sort { |ary1, ary2| ary2.first <=> ary1.first }.each do |multiplier, prefix|
          if value >= multiplier || value < multiplier * -1
            new_value = (value.to_f / multiplier).round(round)
            return "#{ pp_int(new_value) } #{ prefix }#{ unit }"
          end
        end

        return "#{ value } #{ unit }"
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
