#!/bin/sh -e

### BEGIN INIT INFO
# Provides:       devops-compose
# Required-Start: docker
# Required-Stop:  docker
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
### END INIT INFO

PROJECT_DIR=/opt/devops-compose
OPTS=""
PATH="/usr/local/bin:$PATH"

cd "$PROJECT_DIR"

case "$1" in
    start)
        echo "Starting Docker Compose" "$PROJECT_DIR" >&2
        docker-compose $OPTS build
        docker-compose $OPTS up -d
        ;;

    stop)
        echo "Stopping Docker Compose" "$PROJECT_DIR" >&2
        docker-compose $OPTS stop
        ;;

    restart)
        echo "Restarting Docker Compose" "$PROJECT_DIR" >&2
        docker-compose $OPTS build
        docker-compose $OPTS restart
        ;;

    status)
        docker-compose $OPTS ps
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|status}" >&2
        exit 1
        ;;
esac
