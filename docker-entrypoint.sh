#!/bin/bash

if [ -z "$QUEUE" ]; then
    echo "QUEUE not set, aborting..."
    exit 1
fi

if [ -z "$INTERVAL" ]; then
    echo "INTERVAL not set, aborting..."
    exit 1
fi

if [ -z "$RESQUE_SCHEDULER_INTERVAL" ]; then
    echo "RESQUE_SCHEDULER_INTERVAL not set, aborting..."
    exit 1
fi

if [ -z "$RACK_ENV" ]; then
    echo "RACK_ENV not set, aborting..."
    exit 1
fi

echo "Rack env: '$RACK_ENV'"

case "$1" in
    application)
        echo "Starting application server..."
        exec unicorn -c unicorn.conf.rb
        ;;
    worker)
        echo "Starting worker..."
        echo "Listening to queues: '$QUEUE'"
        echo "Polling interval: $INTERVAL"
        exec rake resque:work
        ;;
    scheduler)
        echo "Starting scheduler..."
        echo "Scheduling interval: $RESQUE_SCHEDULER_INTERVAL"
        exec rake resque:scheduler
        ;;
    init)
        # Useful for running a dev-style docker container, 
        # with a SQLite DB *inside* the container.
        echo "Initializing database"
        exec rake sq:create
        ;;
    migrate)
        echo "Applying database migrations"
        exec rake sq:migrate
        ;;
    rake)
        echo "Calling Rake task $2"
        exec rake $2
        ;;
    shell)
        echo "Opening Padrino shell"
        exec padrino c
        ;;

    *)
        echo "Don't know what to do"
        echo "Valid commands: application, worker, scheduler, init, migrate"
        exit 1
esac
