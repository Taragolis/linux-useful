#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

user_name=admin_$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
user_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
host_ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

adduser "$user_name" --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$user_name:$user_pass" | sudo chpasswd
passwd -e "$user_name"
usermod -aG sudo "$user_name"

printf "\n=====================\n"
printf "User: $user_name\nPassword: $user_pass\nHost IPs: $host_ip"
printf "\n\n"
printf "If you want disable user, please run: \nsudo passwd -l $user_name\n\n"
printf "If you want drop user, please run: \nsudo userdel $user_name\n"
