# Helper methods defined here can be accessed in any controller or view in the application

module LouisXiv
  class App
    module UsersHelper
      def login
        verify_user!
        if session.key? 'login_user'
          session['login_user']
        else
          redirect(url(:users, :login))
        end
      end

      def logged_in?
        verify_user!
        session['login_user']
      end
    end

    helpers UsersHelper

    private
    def verify_user!
      if session.key? 'login_user'
        session_user = session['login_user']
        db_user      = User[session_user.id]
        if db_user.nil? || !db_user.active?
          session.delete 'login_user'
        end
      end
    end
  end
end
