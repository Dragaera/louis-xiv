# Helper methods defined here can be accessed in any controller or view in the application

module LouisXiv
  class App
    module UsersHelper
      def login
        if session.key? 'user'
          session['user']
        else
          redirect(url(:users, :login))
        end
      end

      def logged_in?
        session['user']
      end
    end

    helpers UsersHelper
  end
end
