#!/bin/bash

while true
do
prefix=$(osascript -e 'Tell application "System Events" to display dialog "Please enter the department prefix for your computer" default answer ""' -e 'text returned of result' 2>/dev/null)
    if [ $? -ne 0 ]     
    then # user cancel
        exit
    elif [ -z "$prefix" ]
    then # loop until input or cancel
        osascript -e 'Tell application "System Events" to display alert "Please enter a name or select Cancel!" as warning'
    else [ -n "$prefix" ] # user input
        break
    fi
done

serialNumber=$( system_profiler SPHardwareDataType | awk '/Serial Number/ { print $4; }')
shortSerial="-${serialNumber: -8}"

ComputerNameString="$prefix$shortSerial"
"$JAMF_BINARY" setComputerName -name "$ComputerNameString"
scutil --set ComputerName "$ComputerNameString"
scutil --set HostName "$ComputerNameString"
scutil --set LocalHostName "$ComputerNameString"

echo $ComputerNameString

exit 0
