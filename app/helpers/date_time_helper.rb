module LouisXiv
  class App
    module DateTimeHelper
      def pretty_print_date(date, ago: false, alt: '')
        if date
          out = date.strftime('%d.%m.%Y %H:%M:%S')
          out << " (#{ time_ago_in_words(date) } ago)" if ago
        else
          out = alt
        end

        out
      end

      def seconds_to_offset(seconds)
        min, _ = seconds.abs.divmod(60)
        hour, min = min.divmod(60)
        prefix = seconds >= 0 ? '+' : '-'

        format("%s%02i%02i", prefix, hour, min)
      end
    end

    helpers DateTimeHelper
  end
end
