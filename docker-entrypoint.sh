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
        unicorn
        ;;
    worker)
        echo "Starting worker..."
        echo "Listening to queues: '$QUEUE'"
        echo "Polling interval: $INTERVAL"
        rake resque:work
        ;;
    scheduler)
        echo "Starting scheduler..."
        echo "Scheduling interval: $RESQUE_SCHEDULER_INTERVAL"
        rake resque:scheduler
        ;;
    init)
        # Useful for running a dev-style docker container, 
        # with a SQLite DB *inside* the container.
        echo "Initializing database"
        rake sq:create
        ;;
    migrate)
        echo "Applying database migrations"
        rake sq:migrate
        ;;

    *)
        echo "Don't know what to do"
        echo "Valid commands: application, worker, scheduler, init, migrate"
        exit 1
esac
