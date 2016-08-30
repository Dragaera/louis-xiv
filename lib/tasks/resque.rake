require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  desc "Load the Application Development for Resque"
  task :setup => :environment do
    ENV['QUEUES'] = '*'
    # ENV['VERBOSE']  = '1' # Verbose Logging
    # ENV['VVERBOSE'] = '1' # Very Verbose Logging
  end

  task :setup_schedule => :setup do
    Resque.schedule = YAML.load_file('config/schedule.yml')
    # Resque::Scheduler.dynamic = true
  end

  task :scheduler => :setup_schedule
end
