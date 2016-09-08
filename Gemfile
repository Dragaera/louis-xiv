source 'https://rubygems.org'

# Padrino supports Ruby version 1.9 and later
# ruby '2.3.0'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'haml'
gem 'sequel'

gem 'padrino', '0.13.3'

# Application server
gem 'unicorn'

# Background processes
gem 'resque'
gem 'resque-scheduler'

# Evaluating expressions
gem 'dentaku'
# Sane HTTP
gem 'httparty'

# SSH incl using it as a gateway
gem 'net-ssh'
gem 'net-ssh-gateway'

# No way to know which DB the user will use. And due to Docker-based 
# setups, there's no sensible way to have the user install those he needs.
gem 'mysql2'
gem 'pg'
gem 'sequel_pg', require: 'sequel'
gem 'sqlite3'

# SolarLog API client
gem 'sunscout'

group :test do
  gem 'rspec'
  gem 'rack-test', require: 'rack/test'
  gem 'database_cleaner'
  gem 'factory_girl'
end

group :development do
  gem 'pry'
end
