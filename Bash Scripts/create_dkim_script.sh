#!/bin/bash

#Automation of DKIM 
#Script Colors

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'

function getdomain() {

read -p "Which domain? " DOMAIN; 
   stat /var/named/${DOMAIN}.db > /dev/null 2>&1
if [ $? = 1 ];  then   
   echo -e "${RED}Invalid domain or please ensure spelling.${NC}" && getdomain; 
else 
   echo -e "${GREEN}Domain valid.${NC}"
fi 

}

getdomain

grep -E '(^|\s)default._domainkey($|\s)' /var/named/${DOMAIN}.db 1>/dev/null 
 
if [ $? = 0 ];  then
    echo -e "${RED}DKIM already exists. Edit zone${NC}"; 
    	read -r -p "Edit zone file? [Y/n] " response
 		response=${response,,} 

   if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
     echo -e "${CYAN}Backing up zone file...${NC}";  
	      sleep 1s
     	cp -v /var/named/${DOMAIN}.db /var/named/${DOMAIN}.db.$(date +%s)
      	      sleep 2s 
     	vim /var/named/${DOMAIN}.db
   else return 1;
   fi
  
 else
    echo -e "${GREEN}DKIM does not exist.${NC}"
fi

sleep 1s

echo -e "${LGREEN}Checking nameservers...${NC}"
  	sleep 2s
   #dig ${DOMAIN} @8.8.8.8 ns | grep -w 'ns[0-9].*' | awk '{print $5}'
dig ${DOMAIN} @8.8.8.8 ns | grep -Ew 'bluehost.com|justhost.com|hostmonster.com|pipedns|ns[0-9]*' | awk 'NR>1 {print $5}'
  	sleep 2s 

read -r -p "Continue? [Y/n] " response
	 response=${response,,} 
if [[ $response =~ ^([Yy]es|[Yy]) ]] || [[ -z $response ]]; then
   echo -e "${LGREEN}Proceeding...${NC}"
 else return 1; 
fi 

function getlength() {

read -p "1024 or 2048? " user_input;

if [ ${user_input} = 1024 ] || [ ${user_input} = 2048 ]; then
	openssl genrsa -out /var/cpanel/domain_keys/private/${DOMAIN} ${user_input} 1>/dev/null 
     	openssl rsa -in /var/cpanel/domain_keys/private/${DOMAIN} -pubout -out /var/cpanel/domain_keys/public/${DOMAIN} 1>/dev/null
       
echo -e "${GREEN}The following record will be added: ${NC}" 
 echo "default._domainkey IN TXT \"v=DKIM1; k=rsa; p="$(awk '$0 !~ / KEY/{printf $0 }' /var/cpanel/domain_keys/public/${DOMAIN} )\"  

elif [ ${user_input} != 1024 ] || [ ${user_input} != 2048 ]; then
 echo -e "${RED}Wrong key length.${NC}" && getlength;

fi

}

getlength

echo -e "${PURPLE}Backup zone file?${NC}"

read -r -p "[Y/n] " response
 response=${response,,} 
   
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
 echo -e "${CYAN}Backing up zone file...${NC}"; 
	sleep 2s  
     		cp -v /var/named/${DOMAIN}.db /var/named/${DOMAIN}.db.$(date +%s)

     echo -e "${CYAN}Zone file backed up.${NC}"; 
   else echo -e "${RED}Mkay...${NC}"
fi

sleep 1s
	echo -e "${PURPLE}Current Serial...${NC}"
sleep 2s 
	awk 'FNR == 5 {print $1}' /var/named/${DOMAIN}.db

#Set DKIM variable
DKIM=$(awk '$0 !~ / KEY/{printf $0 }' /var/cpanel/domain_keys/public/${DOMAIN}) 

echo -e "${GREEN}Adding to zone file...${NC}"
  sleep 2s

if [ $? = 0 ]; then
	whmapi1 addzonerecord domain=${DOMAIN} name=default._domainkey class=IN ttl=14400 type=TXT txtdata="v=DKIM1; k=rsa; p=${DKIM}" 
fi

echo "Check zone file for formatting errors.";
  sleep 1s

echo -e "${PURPLE}New Serial...${NC}"
 sleep 2s
	awk 'FNR == 5 {print $1}' /var/named/${DOMAIN}.db

sleep 1s

read -r -p "Edit zone file? [Y/n] " response
	response=${response,,} 
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
	vim /var/named/${DOMAIN}.db 
  else echo -e "${GREEN}Bye Felicia!${NC}"

fi


