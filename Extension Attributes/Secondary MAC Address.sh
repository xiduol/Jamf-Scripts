#!/bin/bash

PORT=$(networksetup -listallhardwareports | awk '/Device: en/{print $NF}' | sort | sed -n 2p)

if [ ! -z "$PORT" ]; then
    MACADD=$(ifconfig "$PORT" | awk '/ether/{print $2}' | tr '[a-z]' '[A-Z]')
else
    MACADD=$(ifconfig en0 | awk '/ether/{print $2}' | tr '[a-z]' '[A-Z]')
fi

echo "<result>$MACADD</result>"
