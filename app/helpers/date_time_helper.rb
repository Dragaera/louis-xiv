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
    end

    helpers DateTimeHelper
  end
end
