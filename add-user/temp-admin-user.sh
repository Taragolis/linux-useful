#!/bin/sh -e

#
#  Copyright 2017 Andrey Anshin

#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# You can run this script directly from github as root like this:
#   sudo sh -c "$(wget https://raw.githubusercontent.com/Taragolis/linux-useful/master/add-user/temp-admin-user.sh -qO -)"
# or
#   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/Taragolis/linux-useful/master/add-user/temp-admin-user.sh)"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


user_name=admin_$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
user_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
host_ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

adduser "$user_name" --gecos "Temporary Administrator,dummy,dummy,dummy" --disabled-password
echo "$user_name:$user_pass" | sudo chpasswd
passwd -e "$user_name"

if [ -f /etc/debian_version ]; then
    usermod -aG sudo "$user_name"
elif [ -f /etc/lsb-release ]; then
    usermod -aG wheel "$user_name"
else
    echo "Unknown linux distro. Please add manyally $user_name to admin group"
fi

echo "====================="
echo "User: $user_name\nPassword: $user_pass\nHost IPs: $host_ip"
echo
echo
echo "If you want disable user, please run: \nsudo passwd -l $user_name"
echo
echo "If you want drop user, please run: \nsudo userdel $user_name"
