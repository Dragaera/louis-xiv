RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
Dir[File.expand_path(File.dirname(__FILE__) + "/../app/helpers/**/*.rb")].each(&method(:require))

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end 

  conf.around(:each) do |spec|
    DatabaseCleaner.cleaning do
      spec.run
    end
  end
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
#   app LouisXiv::App
#   app LouisXiv::App.tap { |a| }
#   app(LouisXiv::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
