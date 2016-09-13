namespace :louis do
  desc 'Create an admin user'
  task create_admin_user: :environment do
    print 'Username: '
    username = $stdin.readline.chomp
    if username.empty?
      abort "Username can't be empty!"
    end

    print 'Password: '
    password = $stdin.readline.chomp
    if password.empty?
      abort "Password can't be empty!"
    end

    print 'Password confirmation: '
    password_confirm = $stdin.readline.chomp
    if password != password_confirm
      abort "Password did not match confirmation!"
    end

    User.create(user: username, password: password)
    puts "User successfully created"
  end
end
