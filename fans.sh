#!/bin/bash

# ILO4 login information
ILO4_USER=""
ILO4_PASS=""
ILO4_HOST=""

# Temperature and fan speed settings
MIN_TEMP=10 # The lowest temp you could possibily see, it's recommended you keep this unrealistic. I use 10. 
MAX_TEMP=90 # Max temp you are comfy with, most Xeons are 98C
AGR=9 # A value between 0 - 100, the higher the more aggressive the fans will be 
MIN_SPEED=67 # Minimum speed of fans
MAX_SPEED=255 # Max speed of fans

set_fanSpeed() {
    local fanNum=$1
    local fanSpeed=$2
    sshpass -f "/fanpwd" ssh -oPubKeyAcceptedKeyTypes=+ssh-rsa -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group14-sha1 "$ILO4_USER@$ILO4_HOST" "fan p $fanNum lock $fanSpeed" > /dev/null 2>&1
}

get_max_cpu_temp() {
    sensors | grep 'Core' | awk '{print $3}' | sed 's/+//g; s/°C//g' | sort -nr | head -n 1 | awk -F. '{print $1}'
}

current_temp=$(get_max_cpu_temp)
fanSpeed=$(echo "2 * ($current_temp - 10) + $AGR" | bc)

#Ensure a valid value is sent to ILO
if(( $(echo "$fanSpeed > $MAX_SPEED" | bc -l) )); then
  fanSpeed=$MAX_SPEED
fi

#Temp checks
if (( $(echo "$current_temp > $MAX_TEMP" ) | bc -l )); then
    fanSpeed=$MAX_SPEED
    printf "Fan speed set to max: $fanSpeed\n"
elif (( $(echo "$current_temp < $MIN_TEMP" ) | bc -l )); then
    fanSpeed=$MIN_SPEED
    printf "Fan speed set to min: $fanSpeed\n"
fi

# Iterate through fan 0-5 and set the fan speed
for ((fanNum=0; fanNum<=5; fanNum++)); do
    #printf "SSHing to set: $fanSpeed\n"
    set_fanSpeed $fanNum $fanSpeed
done


