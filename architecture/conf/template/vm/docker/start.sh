#!/bin/sh

echo "Starting Service - SSH"
/etc/init.d/ssh     start > /dev/null
echo ""

echo "Starting Service - Apache2"
/etc/init.d/apache2 start > /dev/null
echo ""

echo "Starting Service - PHP-FPM"
/etc/init.d/php7.3-fpm start  > /dev/null
echo ""

echo "Starting Service - MySQL"
/etc/init.d/mysql   start > /dev/null
echo ""

echo "Starting Service - Redis"
/etc/init.d/redis-server-cache    start > /dev/null
/etc/init.d/redis-server-session  start > /dev/null
echo ""

echo "Starting Service - MailDev"
/etc/init.d/maildev start > /dev/null
echo ""
