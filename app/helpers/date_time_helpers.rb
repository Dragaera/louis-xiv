module LouisXiv
  class App
    module DateTimeHelper
      def pretty_print_date(date, add_ago = false)
        out = date.strftime('%d.%m.%Y %H:%M:%S')
        out << " (#{ time_ago_in_words(date) } ago)" if add_ago

        out
      end
    end

    helpers DateTimeHelper
  end
end
