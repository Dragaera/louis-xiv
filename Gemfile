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

gem 'resque'

gem 'sunscout'

group :test do
  gem 'rspec'
  gem 'rack-test', :require => 'rack/test'
  gem 'database_cleaner'
  gem 'factory_girl'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
end
