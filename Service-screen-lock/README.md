# Script for automatize the screen lock

This script is for automatize the screen lock for the people that have error in the screen lock throug of GUI

The script have by default a value of screen lock expresed in seconds (300 seconds), but you can define a custom value in the execution of script, For use of way default in the system you can define a service of systemd and enable the service for that can execute correctly with the system, if you want define this screen lock in your sistem you must follow the next steps.

- Install package xprintidle
```
sudo apt update && sudo apt install xprintidle -y
```

- Modify file lock.service and define timeout in second of screen lock
```
ExecStart=/usr/bin/lock.sh "Number timeout in Seconds"
```

- Copy file lock.service in path where is all define services systemd
```
sudo cp lock.service /etc/systemd/system/lock.service
```

- Copy file script lock.sh in the path /usr/bin
```
sudo cp lock.sh /usr/bin/lock.sh
```

- Assign privileges of execution in the script lock.sh and enable systemd unit with the next command.
```
sudo chmod +x /usr/bin/lock.sh
sudo systemctl enable lock.service
sudo systemctl daemon-reload
```

