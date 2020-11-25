#!/bin/sh
suspend () {
suspend_second=$1
for x in /tmp/.X11-unix/*; do
    for i in $(loginctl list-users | awk '{ print $1}' | tail -n +2 | head -n -2); do
            runuser -l $(id -un $i) -c "DISPLAY=\":${x#/tmp/.X11-unix/X}\" /usr/bin/xprintidle"
            time=$(runuser -l $(id -un $i) -c "DISPLAY=\":${x#/tmp/.X11-unix/X}\" /usr/bin/xprintidle")
            if [ $time ] ; then
               result=$(($time/1000))
               if [ $result -ge $suspend_second ]; then
                  systemctl suspend
               fi
            fi
    done
    sleep 5
done
}


number=$(echo "$1" | awk '$0 ~/[^0-9]/ { print "1" }')

if [ -z $number ]; then
    suspend_second=$1
    echo "$suspend_second" > /etc/time_suspend
else
    if [ -f /etc/time_suspend ]; then
        suspend_second=$(cat /etc/time_suspend)
    else
        echo "600" > /etc/time_suspend
        suspend_second=$(cat /etc/time_suspend)
    fi
fi

while :
do
    suspend $suspend_second
    sleep 1
done

