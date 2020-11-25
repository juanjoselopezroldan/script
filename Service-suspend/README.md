# Script for automatize the machine suspend

This script is for automatize the process of machine suspend for the people that have error in the machine suspend throug of GUI

The script has a default value of suspend the machine expressed in seconds (600 seconds), but you can define a custom value in the execution of the script. For its use by default in the system, you can define a systemd service and enable the service so that it can run correctly with the system, if you want to define a time for that the is suspended machine in your system you must follow the following steps.

- Modify the suspend.service file and define the timeout in seconds for that the machine enter in mode suspension
```
ExecStart=/usr/bin/suspend.sh  "Number timeout in Seconds"
```

- Copy file suspend.service in path where is all define services systemd
```
sudo cp suspend.service /etc/systemd/system/suspend.service
```

- Copy file script suspend.sh in the path /usr/bin
```
sudo cp suspend.sh /usr/bin/suspend.sh
```

- Assign privileges of execution in the script suspend.sh and enable systemd unit with the next command.
```
sudo chmod +x /usr/bin/suspend.sh
sudo systemctl enable suspend.service
sudo systemctl daemon-reload
```


