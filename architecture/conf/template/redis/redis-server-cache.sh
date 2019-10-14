#!/bin/sh -e
### BEGIN INIT INFO
# Provides:          redis-server-cache
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: redis-server-cache
### END INIT INFO

DAEMON="/usr/bin/redis-server"
daemon_OPT="/etc/redis/redis-cache.conf"
DAEMONUSER="root"
daemon_NAME="redis-server-cache"

PATH="/sbin:/bin:/usr/sbin:/usr/bin"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

d_start () {
    log_daemon_msg "Starting system $daemon_NAME Daemon"
    start-stop-daemon --background --name $daemon_NAME --start --quiet --chuid $DAEMONUSER --exec $DAEMON -- $daemon_OPT
    log_end_msg $?
}

d_stop () {
    log_daemon_msg "Stopping system $daemon_NAME Daemon"
    start-stop-daemon --name $daemon_NAME --stop --retry 5 --quiet --name $daemon_NAME
    log_end_msg $?
}

case "$1" in
    start)
        d_start
        ;;

    stop)
        d_stop
        ;;

    restart|reload|force-reload)
        d_stop
        d_start
        ;;

    force-stop)
       d_stop
        killall -q $daemon_NAME || true
        sleep 2
        killall -q -9 $daemon_NAME || true
        ;;

    status)
        status_of_proc "$daemon_NAME" "$DAEMON" "system-wide $daemon_NAME" && exit 0 || exit $?
        ;;

    *)
        echo "Usage: /etc/init.d/$daemon_NAME {start|stop|force-stop|restart|reload|force-reload|status}"
        exit 1
        ;;
esac
exit 0
