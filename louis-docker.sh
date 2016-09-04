#!/bin/bash

DOCKER_IMAGE=lavode/louis_xiv:latest
DOCKER_NETWORK=louis
ENV_FILE=docker.env

function main {
    case "$1" in
        start)
            start_all $@
            ;;
        stop)
            stop_all $@
            ;;
        start-application)
            start_application $@
            ;;
        start-worker)
            start_worker $@
            ;;
        start-scheduler)
            start_scheduler $@
            ;;
        start-redis)
            start_redis $@
            ;;
        stop-application)
            stop_application $@
            ;;
        stop-worker)
            stop_worker $@
            ;;
        stop-scheduler)
            stop_scheduler $@
            ;;
        stop-redis)
            stop_redis $@
            ;;
        migrate)
            migrate $@
            ;;
        setup)
            setup $@
            ;;
        teardown)
            teardown $@
            ;;
        shell)
            shell $@
            ;;
        *)
            echo "Don't know what to do"
            echo "Valid options: start, stop, start-application, start-worker, start-scheduler, start-redis, stop-application, stop-worker, stop-scheduler, stop-redis, migrate, setup, teardown, shell"
    esac
}

function start_application {
    docker rm louis-application$2 2>/dev/null
    docker run --env-file=$ENV_FILE --name=louis-application$2 --network=$DOCKER_NETWORK -p 8080:8080 -d $DOCKER_IMAGE application
}

function start_worker {
    docker rm louis-worker$2 2>/dev/null
    docker run --env-file=$ENV_FILE --name=louis-worker$2 --network=$DOCKER_NETWORK -d $DOCKER_IMAGE worker
}

function start_scheduler {
    docker rm louis-scheduler$2 2>/dev/null
    docker run --env-file=$ENV_FILE --name=louis-scheduler$2 --network=$DOCKER_NETWORK -d $DOCKER_IMAGE scheduler
}

function start_redis {
    docker rm louis-redis 2>/dev/null
    docker run --name=louis-redis --network=$DOCKER_NETWORK -d redis
}

function start_all {
    start_redis
    start_application
    start_worker
    start_scheduler
}

function stop_application {
    docker stop louis-application$2
}

function stop_worker {
    docker stop louis-worker$2
}

function stop_scheduler {
    docker stop louis-scheduler$2
}

function stop_redis {
    docker stop louis-redis
}

function stop_all {
    stop_application
    stop_scheduler
    stop_worker
    stop_redis
}

function migrate {
    docker rm louis-migrate 2>/dev/null
    docker run --env-file=$ENV_FILE --name=louis-migrate --network=$DOCKER_NETWORK $DOCKER_IMAGE migrate
    docker rm louis-migrate
}

function setup {
    teardown
    docker network create --driver bridge $DOCKER_NETWORK
    migrate
}

function teardown {
    stop_all
    docker network rm $DOCKER_NETWORK 2>/dev/null
}

function shell {
    docker rm louis-shell 2>/dev/null
    docker run -it --env-file=$ENV_FILE --name=louis-shell --network=$DOCKER_NETWORK --entrypoint=/bin/bash $DOCKER_IMAGE
    docker rm louis-shell
}

main $@
