#!/bin/bash

echo " > Redis - Install"

apt-get -qq -y install redis-server > /dev/null

echo " > Redis - Configure"

rm -f                    /etc/redis/redis-cache.conf
cp /etc/redis/redis.conf /etc/redis/redis-cache.conf
chown redis:redis        /etc/redis/redis-cache.conf
sed -i -e 's@^dbfilename .*@dbfilename dump-cache.rdb@'                                        /etc/redis/redis-cache.conf
sed -i -e 's@^bind .*@bind 127.0.0.1@'                                                         /etc/redis/redis-cache.conf
sed -i -e 's@^port .*@port 6379@'                                                              /etc/redis/redis-cache.conf
sed -i -e 's@^databases .*@databases 2@'                                                       /etc/redis/redis-cache.conf
sed -i -e 's@^logfile .*@logfile /var/log/redis/redis-server-cache.log@'                       /etc/redis/redis-cache.conf
sed -i -e 's@^pidfile .*@pidfile /var/run/redis-cache/redis-server.pid@'                       /etc/redis/redis-cache.conf

rm -f                    /etc/redis/redis-session.conf
cp /etc/redis/redis.conf /etc/redis/redis-session.conf
chown redis:redis        /etc/redis/redis-session.conf
sed -i -e 's@^dbfilename .*@dbfilename dump-session.rdb@'                                      /etc/redis/redis-session.conf
sed -i -e 's@^bind .*@bind 127.0.0.1@'                                                         /etc/redis/redis-session.conf
sed -i -e 's@^port .*@port 6380@'                                                              /etc/redis/redis-session.conf
sed -i -e 's@^databases .*@databases 1@'                                                       /etc/redis/redis-session.conf
sed -i -e 's@^logfile .*@logfile /var/log/redis/redis-server-session.log@'                     /etc/redis/redis-session.conf
sed -i -e 's@^pidfile .*@pidfile /var/run/redis-session/redis-server.pid@'                     /etc/redis/redis-session.conf

echo " > Redis - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    rm -f /etc/init.d/redis-server-cache
    cp /etc/init.d/redis-server /etc/init.d/redis-server-cache
    sed -i -e 's@redis.conf@redis-cache.conf@'                                      /etc/init.d/redis-server-cache
    sed -i -e 's@^NAME=.*@NAME=redis-server-cache@'                                 /etc/init.d/redis-server-cache
    sed -i -e 's@^DESC=.*@DESC=redis-server-cache@'                                 /etc/init.d/redis-server-cache
    sed -i -e 's@^RUNDIR=.*@RUNDIR=/var/run/redis-cache@'                           /etc/init.d/redis-server-cache

    rm -f /etc/init.d/redis-server-session
    cp /etc/init.d/redis-server /etc/init.d/redis-server-session
    sed -i -e 's@redis.conf@redis-session.conf@'                                   /etc/init.d/redis-server-session
    sed -i -e 's@^NAME=.*@NAME=redis-server-session@'                              /etc/init.d/redis-server-session
    sed -i -e 's@^DESC=.*@DESC=redis-server-session@'                              /etc/init.d/redis-server-session
    sed -i -e 's@^RUNDIR=.*@RUNDIR=/var/run/redis-session@'                        /etc/init.d/redis-server-session

    /etc/init.d/redis-server stop
    /etc/init.d/redis-server-cache start
    /etc/init.d/redis-server-session start

    update-rc.d -f redis-server         remove
    update-rc.d    redis-server-cache   defaults
    update-rc.d    redis-server-session defaults
else
    systemctl disable -q redis-server
    systemctl stop    -q redis-server

    systemctl enable -q redis-server@cache
    systemctl start  -q redis-server@cache

    systemctl enable -q redis-server@session
    systemctl start  -q redis-server@session
fi

echo " > Redis - Test - Cache"

redis-cli -h 127.0.0.1 -p 6379 info server | egrep "process_id|tcp_port|config_file"

echo " > Redis - Test - Session"

redis-cli -h 127.0.0.1 -p 6380 info server | egrep "process_id|tcp_port|config_file"
