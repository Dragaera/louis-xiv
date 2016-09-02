module LouisXiv
  class App
    module ModelHelper
      def get_or_404(cls, key, msg = nil)
        obj = cls[key]

        if obj.nil?
          msg = "No #{ cls.name } with id #{ key }" unless msg
          raise Sinatra::NotFound, msg
        end

        obj
      end
    end

    helpers ModelHelper
  end
end
