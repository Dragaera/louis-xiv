# Helper methods defined here can be accessed in any controller or view in the application

module LouisXiv
  class App
    module ModelHelperHelper
      def get_or_404(cls, key, msg = nil)
        obj = cls[key]

        if obj.nil?
          msg = "No #{ cls.name } with id #{ key }" unless msg
          raise Sinatra::NotFound, msg
        end

        obj
      end
    end

    helpers ModelHelperHelper
  end
end
