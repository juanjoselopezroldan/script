#!/bin/sh
lock () {
lock_second=$1
for x in /tmp/.X11-unix/*; do
    for i in $(loginctl list-users | awk '{ print $1}' | tail -n +2 | head -n -2); do
            runuser -l $(id -un $i) -c "DISPLAY=\":${x#/tmp/.X11-unix/X}\" /usr/bin/xprintidle"
            time=$(runuser -l $(id -un $i) -c "DISPLAY=\":${x#/tmp/.X11-unix/X}\" /usr/bin/xprintidle")
            if [ $time ] ; then
               result=$(($time/1000))
               if [ $result -ge $lock_second ]; then
                  /bin/loginctl lock-sessions
               fi
            fi
    done
    sleep 5
done
}

number=$(echo "$1" | awk '$0 ~/[^0-9]/ { print "1" }')

if [ -z $number ]; then
    lock_second=$1
    echo "$lock_second" > /etc/lock
else
    if [ -f /etc/lock ]; then
        lock_second=$(cat /etc/lock)
    else
        echo "300" > /etc/lock
        lock_second=$(cat /etc/lock)
    fi
fi

while :
do
    lock $lock_second
    sleep 1
done
