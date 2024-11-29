#!/bin/sh
#########

##Get current date time
current_date() {
    date +"%Y-%m-%d %H:%M:%S"
}

## Set threshold for free space in percentage (e.g., 20 means 20%)
THRESHOLD_WARNING=30
THRESHOLD_CRITICAL=60

check_system_info() {
   echo "                           \033[33;5;7mSystem Up time \033[0m "
  # echo "-----------------------------------------------------------" 
   #UPTIME=$(uptime | awk '{print $3 " " $4}');
   UPTIME=$(uptime | awk '{print $3}');

   ##echo $UPTIME

    if [ "$UPTIME" -ge "$THRESHOLD_CRITICAL" ]; then
        echo "CRITICAL: System uptime is $UPTIME days. Consider rebooting the machine."
    elif [ "UPTIME" -ge "$THRESHOLD_WARNING" ]; then
        echo "WARNING: System uptime is $UPTIME days. Monitor the system closely."
    else
        echo "OK: System uptime is $UPTIME days. No action needed."
fi

}

## Function to check disk space
check_disk_space() {
    ##echo "Checking disk space on $(date)"
    echo "                        \033[33;5;7mChecking disk space \033[0m  "
    echo "---------------------------------------------------------------------"

    # Use df to get disk usage and process it with awk
    df -H | grep "/dev/" | while read -r line; do
        DEVICE=$(echo "$line" | awk '{print $1}')
        MOUNT=$(echo "$line" | awk '{print $NF}')
        USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')

        echo "Disk: $DEVICE Mounted on: $MOUNT Usage: $USAGE%"

        # Check if usage exceeds threshold
        if [ "$USAGE" -gt $((100 - THRESHOLD)) ]; then
            echo "WARNING: Low disk space on $MOUNT ($USAGE% used)"
            # Optionally, send an alert (e.g., email or system notification)
        fi
    done
    echo "---------------------------------------------------------------------"
}








echo "---------------------------------------------------------------------"
echo "                            \033[33;5;7mCurrent date \033[0m  [$(current_date)] "
echo "---------------------------------------------------------------------"
echo "                           \033[33;5;7mmacOS Version:\033[0m $(sw_vers -productVersion) "
echo "---------------------------------------------------------------------"

## Run the disk space check
check_system_info
echo "---------------------------------------------------------------------"
check_disk_space

###Top 5 CPU usage processess
echo "                          \033[33;5;7mTop 5 CPU usage \033[0m  "
echo "---------------------------------------------------------------------"
top -l 5 | grep "CPU usage" | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8}'
echo "---------------------------------------------------------------------"

###Top 5 memory usage processess
echo "                         \033[33;5;7mTop 5 Memory usage \033[0m  "
echo "---------------------------------------------------------------------"
top -l 5 | grep "PhysMem" | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8}'
echo "---------------------------------------------------------------------"

