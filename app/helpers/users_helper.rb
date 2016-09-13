# Helper methods defined here can be accessed in any controller or view in the application

module LouisXiv
  class App
    module UsersHelper
      def login
        if session.key? 'login_user'
          session['login_user']
        else
          redirect(url(:users, :login))
        end
      end

      def logged_in?
        session['login_user']
      end
    end

    helpers UsersHelper
  end
end
