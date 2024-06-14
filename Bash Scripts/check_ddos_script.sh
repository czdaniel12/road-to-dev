#!/bin/bash 

# Grab user for domain(s) in question.

function getuser() {

read -p "Which user? " USER;
 awk -F: '{print$1}' /etc/shadow | grep -w $USER 1>/dev/null 

if [ $? = 1 ] 
 then
  echo "User not found, please try again."
  getuser
 else 
  echo "Using... $USER"
fi

} 

getuser
 sleep 1s

# Grab specific domain. 

function getdomain() {

read -p "Which domain? " DOMAIN;
 stat /var/named/${DOMAIN}.db > /dev/null 2>&1

if [ $? = 1 ] 
 then
  echo "Unable to locate domain, please confirm."
  getdomain
 else 
  echo "Domain valid, proceeding."
fi

}

getdomain

# Check if domain entered is primary or addon.

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]] 
 then
  echo "Domain is not primary"
 else
  echo "Domain is primary"
fi

 sleep 1s
  echo "Grabbing top IPs for domain..."
 sleep 2s

PRIMARY=$(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main)
ADDON=$(echo $DOMAIN | awk -F'.' '{print $1}') 
SUB=$(awk '/${ADDON}./{print $2}' /var/cpanel/userdata/${USER}/main | uniq)

echo "${ADDON}.${PRIMARY}"

# Search for top IPs on domain given. 

function getip() {

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) = $DOMAIN ]]
 then
  awk '{print $1}' /usr/local/apache/domlogs/$DOMAIN | sort | uniq -c | sort -rn | head
 elif [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]]
  then
    echo $SUB
    awk '{print $1}' /usr/local/apache/domlogs/$SUB | sort | uniq -c | sort -rn | head
fi

} 

getip 
