#!/bin/bash

path_execute='/DIRECTORY CHECK'
dumps=$(find $path_execute -mtime -2 -type f -exec ls -liah {} + | awk '{ print $6,$NF }' | tr -s ' ' '~')
RED='\033[0;31m'
WHITE='\033[1;37m'
NOCOLOR='\033[0m'
lastdirectory=''
lastsize=''
set -x
for d in $(echo "$dumps");
do
        path=$(echo $d | cut -d '~' -f2)
        positiondirectory=$(echo $path | tr -s '/' ' ' | wc -w)
        nowdirectory=$(echo $path | cut -d '/' -f 1-$(($positiondirectory)))
        nowsize=$(echo $d | cut -d '~' -f1)
        filetodaycreate=$(stat -c '%y' $path | awk '{print $1 }')

        if [[ $nowdirectory == $lastdirectory ]]; then
                if [[ $nowsize != $lastsize ]]; then
                        echo -e "$WHITE [INFO] Directory with file $path $NOCOLOR"
                        echo -e " - Size yesterday: $lastsize"
                        echo -e " - Size today: $nowsize"
                elif [[ $filetodaycreate != $(date '+%Y-%m-%d') ]] ; then
                        echo -e "$RED [ERROR] The backup of directory $nowdirectory didn't the backup correctly $NOCOLOR"
                else
                        echo -e "$WHITE [INFO] Directory with file $path $NOCOLOR"
                        echo -e " - The file of today and yesterday have the some size ($nowsize)"
                fi
        else
                lastdirectory="$nowdirectory"
                lastsize="$nowsize"
        fi
done



