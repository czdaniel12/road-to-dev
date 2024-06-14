#!/bin/bash

# This script is for ease of use with assisting customer with their PCI Compliance scans. 

# The majority of this information is copy & paste from:

# 

# 


read -p "Which user? " USER;

cd /home/$USER/public_html

mkdir changelogs && chown $USER:$USER changelogs

echo "Directory 'changelogs' created in pub_h."

#HOSTNAME= ${hostname -I} 

echo "Reply y if the issue is a fail point; copy & paste response."



read -r -p "TLS Version 1.0 Protocol Detection? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; 
  then
    echo "Our servers currently support the most recent version of TLS 1.2. 

openssl ciphers -v | awk '{print $2}' | sort | uniq
SSLv3
TLSv1.2

You will want to consult a web developer about this, and have them ensure that your website, including the builder used, plugins, themes and so on, is up-to-date. This could often be a result of specific coding used within the website files calling to the old protocol. Server-side, this should be correct and we do not force use of the older TLS 1.0."
fi



read -r -p "Plaintext authentication is allowed over unencrypted channel on SMTP? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "Regarding Plaintext authentication is allowed over unencrypted channel on SMTP (port 25, 26): According to PCI DSS Requirement 3, PCI data is not to be sent using end-user messaging technologies such as email. Please have your ASV mark these cases as a false positive." && echo "<NOTE: This reply is to test the response we get, as PCI data should not be sent over email. To avoid just closing ports for not reason, we should see if the ASV will agree. Otherwise, we'd have to close the respective ports.>"
fi



read -r -p "Weak SSH Server Host Key Supported? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; 
  then
     grep -nri dss /etc/ssh* | awk '{print $1}' && ssh-keygen -l -f /etc/ssh/ssh_host_key && echo "Your ASV should be able to mark this as a false positive. Here is the current key information <insert output>" && echo "NOTE: I'm not entirely clear on the response we should give them for this. If the above does not work for the ASV, then we may not be able to help." 
fi



read -r -p "Web Application Potentially Vulnerable to Clickjacking? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "Web Application Potentially Vulnerable to Clickjacking (multiple ports): Unfortunately, we are not able to assist with items like these and it will need to be addressed by a professional developer."
fi



read -r -p "FTP Supports Cleartext Authentication? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo " Regarding FTP Supports Cleartext Authentication (port 21): This port would need to be disabled to pass the PCI compliance scan. FTP will still be accessible by using the server's primary IP address which is <insert IP>. Please let us know if you would like for us to move forward with disabling this port."
fi



read -r -p "TLS/SSL Server Supports Weak Cipher Algorithms? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "RC4 is disabled on the server. Please see the following scan from SSL Labs on your SSL Certificate, and note the line that says RC4: No.

https://www.ssllabs.com/ssltest/analyze.html?d=domain.com&latest (insert domain)"
fi



read -r -p "SMTP Server Non-standard Port Detection (Port 26)? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "Regarding SMTP Server Non-standard Port Detection (port 26): Port 26 being open is common practice due to ISPs blocking port 25 preventing SMTP traffic. Please have your ASV mark this case as a false positive."
fi



read -r -p "Web Server HTTP Header Information Disclosure? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "Regarding Web Server HTTP Header Information Disclosure (multiple ports): This is a web standard and cannot be changed. Please have your ASV mark this as a false positive."
fi



read -r -p "SWEET32/3DES? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     echo "Regarding OpenSSL / SWEET32 / 3DES Ciphers (multiple ports): These are false positives. Our servers still use 3DES due to legacy devices, but it's at the bottom of the cipher list and we have our servers set to prefer server cipher order. We also have keepalivetimeout set to the default, 5 seconds. As the CVE-2016-2183 attack vectors would pertain to modern clients negotiating a 3DES connection with the server, they can be disputed as false positives due to the 3DES cipher only affecting old legacy clients, at which point it would be a client-side issue, and not server-side. Even if a legacy client would establish a 3DES based session, the low keepalivetimeout, patched OpenSSL, and firewall rules would not permit a successful attack."
fi



read -r -p "Exim (Multiple vulnerabilities)? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     rpmcve() { pkg=$(rpm -qf $(which ${1})) && rpm -qi ${pkg} && rpm -qi --changelog ${pkg} | grep 'CVE-' ; } ; rpmcve exim > /home/$USER/public_html/changelogs/exim_changelog.txt && echo "Regarding Exim (multiple ports): Please provide the following information to the ASV and have these cases marked as false positives." && echo "<NOTE: exim_changelog.txt generated; please download and attach to email.>"
fi



read -r -p "SSL/TLS Protocol Initialization Vector Implementation Information Disclosure Vulnerability? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     rpmcve() { pkg=$(rpm -qf $(which ${1})) && rpm -qi ${pkg} && rpm -qi --changelog ${pkg} | grep 'CVE-' ; } ; rpmcve openssl > /home/$USER/public_html/changelogs/openssl_changelog.txt && echo "Regarding SSL/TLS Protocol Initialization Vector Implementation Information Disclosure Vulnerability (multiple ports): Please provide the following information to the ASV and have these cases marked as false positives." && echo "<NOTE: openssl_changelog.txt generated; please download and attach to email.>"
fi



read -r -p "OpenSSH (Multiple Vulnerabilities)? [Y/n] " response
 response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
  then
     rpmcve() { pkg=$(rpm -qf $(which ${1})) && rpm -qi ${pkg} && rpm -qi --changelog ${pkg} | grep 'CVE-' ; } ; rpmcve sshd > /home/$USER/public_html/changelogs/openssh_changelog.txt && echo "Please provide the following information to the ASV and have these cases marked as false positives." && echo "<NOTE: openssh_changelog.txt generate; please download and attach to email.>"
fi


chown $USER. /home/$USER/public_html/changelogs/*changelog.txt 2>/dev/null

rmdir changelogs 2>/dev/null

echo "END OF PCI SCRIPT. If there are any vulnerabilites not covered here, let me know and I will see about adding a response. Some remaining fail points are likely not documented on our end, meaning additional research must be done to provide a better answer."


