#!/bin/bash

# Get the currently logged-in console user
currentUser=$(stat -f%Su /dev/console)

# Get a list of all user accounts with UIDs above 500
userList=$( /usr/bin/dscl /Local/Default list /Users uid | /usr/bin/awk '$2 >= 503 { print $1 }' )

# Specify the accounts that you want to exclude
excludedUsers=("templejamf" "clientsvcs")

echo "Current logged-in user: $currentUser"

# Loop through the user list and delete user profiles except admin accounts
for user in $userList; do

    # Skip excluded users
    if [[ " ${excludedUsers[@]} " =~ " ${user} " ]]; then
        echo "Skipping excluded user: $user"
        continue
    fi

    # Skip the currently logged-in user
    if [[ "$user" == "$currentUser" ]]; then
        echo "Skipping currently logged-in user: $user"
        continue
    fi

    echo "Deleting user: $user..."
    # sysadminctl -deleteUser $user
    jamf deleteAccount -username "$user" -deleteHomeDirectory

done