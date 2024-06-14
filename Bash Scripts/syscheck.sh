#!/bin/bash 

bold=$(tput bold)
normal=$(tput sgr0)

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

cd /home/$USER/public_html/
 echo "Changing to homedir..."
sleep 1s
 echo "Creating report file..."
sleep 1s
  touch system_report.txt
   chown $USER:$USER system_report.txt
 echo "Output will be sent here as well."
sleep 2s

function vpscheck() {

echo "Checking usage..."
 sleep 1s 
  echo "${bold}USAGE:${normal}"; df -h | awk 'NR < 3 {print $1 ":  " $5}'
 sleep 1s
  echo "${bold}INODES:${normal}"; df -ih | awk 'NR < 3 {print $2 ":  " $4}';
 sleep 1s
  echo "${bold}MEMORY:${normal}"; free -mh | awk 'NR < 3 {print $2 ":  " $3}';
 sleep 1s

echo "Checking services..."
 sleep 1s  
  echo "${bold}SERVICES STATUS:${normal}";
   service httpd status
  sleep 1s
    service nginx status 2>/dev/null
  sleep 1s
     service exim status;
  sleep 1s
      service mysql status;
  sleep 1s
       service pure-ftpd status;
 sleep 1s

echo "Checking load..."
 sleep 1s
  echo "${bold}LOAD:${normal}"; sar -q | awk 'NR > 1'; top -b -n  1  | awk '/load average/ { printf "%s %s %s\n", $10, $11, $12 }';
 
} 

read -p "Shared or VPS? " user_input;

if [[ $user_input = [Ss]hared ]] 
 then
  echo "Checking shared statistics."
 elif [[ $user_input = [Vv][Pp][Ss] ]] 
 then 
  vpscheck
fi

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

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]] 
 then
  echo "Checking for addon domain."
 else
  ECHo "Checking for primary domain."
fi

 sleep 1s
  echo "Grabbing top IPs for domain..."
 sleep 2s

PRIMARY=$(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main)
ADDON=$(echo $DOMAIN | awk -F'.' '{print $1}') 
SUB="${ADDON}.${PRIMARY}"
#SUB="$(awk '/${ADDON}./{print $2}' /var/cpanel/userdata/${USER}/main | uniq)"

function getip() {

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) = $DOMAIN ]]
 then
  echo "Non-SSL:"
   awk '{print $1}' /usr/local/apache/domlogs/$DOMAIN | sort | uniq -c | sort -rn | head 
   sleep 1s
    echo "With SSL:"
     awk '{print $1}' /usr/local/apache/domlogs/$DOMAIN-ssl_log | sort | uniq -c | sort -rn | head
 elif [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]]
  then
   echo "Non-SSL:"
    awk '{print $1}' /usr/local/apache/domlogs/$SUB | sort | uniq -c | sort -rn | head
    sleep 1s
     echo "With SSL:"
      awk '{print $1}' /usr/local/apache/domlogs/$SUB-ssl_log | sort | uniq -c | sort -rn | head
fi

} 

getip 
 sleep 1s
  echo "Grabbing top URLs..."
 sleep 2s

function geturl() {

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) = $DOMAIN ]]
 then
  echo "Non-SSL:"
   awk '{print $7}' /usr/local/apache/domlogs/$DOMAIN | sort | uniq -c | sort -rn | head
   sleep 1s
    echo "With SSL:"
     awk '{print $7}' /usr/local/apache/domlogs/$DOMAIN-ssl_log | sort | uniq -c | sort -rn | head
 elif [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]]
  then
   echo "Non-SSL:"
    awk '{print $7}' /usr/local/apache/domlogs/$SUB | sort | uniq -c | sort -rn | head
    sleep 1s
     echo "With SSL:"
      awk '{print $7}' /usr/local/apache/domlogs/$SUB-ssl_log | sort | uniq -c | sort -rn | head
fi

} 

geturl

sleep 1s
 echo "Checking user processes for $USER"
sleep 2s

ps uU $USER

sleep 1s
 echo "Checking crontab..."
sleep 2s

crontab -lu $USER

sleep 1s 

read -r -p "Run email check? [Y/n] " response
response=${response,,} 

if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
    ec $DOMAIN | awk 'NR>37'
fi

function sendtoreport() {

echo "Statistics for $DOMAIN" 1>/dev/null >> system_report.txt
 echo "" >> system_report.txt
  echo "" >> system_report.txt

echo "Top IPs:" >> system_report.txt

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) = $DOMAIN ]]
 then
  echo "Non-SSL:" >> system_report.txt
   awk '{print $1}' /usr/local/apache/domlogs/$DOMAIN | sort | uniq -c | sort -rn | head >> system_report.txt
  echo "With SSL:" >> system_report.txt
   awk '{print $1}' /usr/local/apache/domlogs/$DOMAIN-ssl_log | sort | uniq -c | sort -rn | head >> system_report.txt
 elif [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]]
  then
   echo "Non-SSL:" >> system_report.txt
    awk '{print $1}' /usr/local/apache/domlogs/$SUB | sort | uniq -c | sort -rn | head >> system_report.txt
   echo "With SSL:" >> system_report.txt
    awk '{print $1}' /usr/local/apache/domlogs/$SUB-ssl_log | sort | uniq -c | sort -rn | head >> system_report.txt
fi

echo "" >> system_report.txt

echo "Top URLs:" >> system_report.txt

if [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) = $DOMAIN ]]
 then
  echo "Non-SSL:" >> system_report.txt
   awk '{print $7}' /usr/local/apache/domlogs/$DOMAIN | sort | uniq -c | sort -rn | head >> system_report.txt
  echo "With SSL:" >> system_report.txt
   awk '{print $7}' /usr/local/apache/domlogs/$DOMAIN-ssl_log | sort | uniq -c | sort -rn | head >> system_report.txt
 elif [[ $(awk '/^main_domain/{print $2}' /var/cpanel/userdata/${USER}/main) != $DOMAIN ]]
  then
   echo "Non-SSL:" >> system_report.txt
    awk '{print $7}' /usr/local/apache/domlogs/$SUB | sort | uniq -c | sort -rn | head >> system_report.txt
   echo "With SSL:" >> system_report.txt
    awk '{print $7}' /usr/local/apache/domlogs/$SUB-ssl_log | sort | uniq -c | sort -rn | head >> system_report.txt
fi

echo "" >> system_report.txt
 echo "User processes:" >> system_report.txt

ps uU $USER >> system_report.txt

echo "" >> system_report.txt
 echo "Email check:" >> system_report.txt
ec $DOMAIN | awk 'NR>37' >> system_report.txt

}

sendtoreport

function anotherdomain() {

read -r -p "Check another domain? [Y/n] " response
response=${response,,}

if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
 then 
  getdomain
   getip
    geturl
fi

} 

#anotherdomain

echo "You can find the report at /home/$USER/public_html/system_report.txt*" 
 mv system_report.txt{,.$(date +%F)} 
