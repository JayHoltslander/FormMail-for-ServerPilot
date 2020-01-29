#!/bin/bash
clear
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
DARKYELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${YELLOW}===============================================================
  FormMail for ServerPilot Apps
===============================================================${NC}
This script will configure your ServerPilot App to use FormMail
and create a sample form page as a starter point.
It has only been tested on DigitalOcean servers.
"
echo -e "Basically this is automation of: 
* https://serverpilot.io/docs/how-to-create-a-cgi-bin-directory/
* http://www.scriptarchive.com/formmail.html
"
echo -e "
DigitalOcean:
What is the Droplet's ${WHITE}IP Address${NC}?
(eg: 321.456.789.456) [Ctrl-C to cancel]"
read IPADDRESS
echo -e "
ServerPilot:
What is the ${WHITE}App name${NC} you created for the site as defined in ServerPilot?
(Case-sensitive) [Ctrl-C to cancel]"
read APPNAME
echo -e "
ServerPilot:
What is the ${WHITE}domain${NC} that the app runs on as defined in ServerPilot?
(eg: appname.domain.com) [Ctrl-C to cancel]"
read DOMAIN
echo -e "
ServerPilot:
What is the ${WHITE}system user${NC} name for the site as defined in ServerPilot?
(Case-sensitive) [Ctrl-C to cancel]"
read USERNAME
echo -e "
FormMail:
What ${WHITE}other domains${NC} might be used as a recipient for your test form submissions?
(eg: otherdomain.net) [Ctrl-C to cancel]"
read RECIPIENTDOMAIN
echo -e "
FormMail:
What ${WHITE}recipient${NC} on ${RECIPIENTDOMAIN} or ${DOMAIN} should be used for your test form submissions?
(eg: john not john@) [Ctrl-C to cancel]"
read RECIPIENT
echo -e "
Ok, FormMail will be configured so that either ${RECIPIENT}@${RECIPIENTDOMAIN} or ${RECIPIENT}@${DOMAIN} will work
"
echo -e "
${YELLOW}
==============================================================================
CONFIRM:
Your existing ServerPilot App \"$APPNAME\" (owned by the user \"$USERNAME\")
on $IPADDRESS will be configured so that $DOMAIN can use FormMail.

The test form created will be set to send its submissions to:
$RECIPIENT@$RECIPIENTDOMAIN but it will still work if you change it to an
$DOMAIN address later.
==============================================================================${RED}
"
read -p "Are you sure?$ " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "
${NC}Creating /etc/apache-sp/vhosts.d/${APPNAME}.d/cgi-bin.conf on ${IPADDRESS}...
"
ssh -t root@$IPADDRESS 'touch /etc/apache-sp/vhosts.d/'${APPNAME}'.d/cgi-bin.conf && printf "Define CGI_BIN \${DOCUMENT_ROOT}/../cgi-bin/\nScriptAlias /cgi-bin/ \${CGI_BIN}\n<Directory \${CGI_BIN}>\nRequire all granted\n</Directory>\n" >> /etc/apache-sp/vhosts.d/'${APPNAME}'.d/cgi-bin.conf && sudo service apache-sp restart'
echo -e "Config file created, service apache-sp restarted."
echo -e "
Logging back in as $USERNAME to create the cgi-bin directory, a test script, and set their permissions.
"
ssh -t $USERNAME@$IPADDRESS 'mkdir ~/apps/'$APPNAME'/cgi-bin && chmod 755 ~/apps/'$APPNAME'/cgi-bin && touch ~/apps/'$APPNAME'/cgi-bin/status.sh && printf "#!/bin/bash\necho \"Content-type: text/html\"\necho\necho \"<h1>cgi-bin is ready</h1>\" \necho \"This file is located at and running from <code>apps/'${APPNAME}'/cgi-bin/status.sh</code> which is one folder level up from within your sites <code>/public</code></br></br>\"\necho\necho \"SFTP in as your ServerPilot user to access this file.\"" >> ~/apps/'$APPNAME'/cgi-bin/status.sh && chmod 755 ~/apps/'$APPNAME'/cgi-bin/status.sh'
open https://$DOMAIN/cgi-bin/status.sh
echo -e "
Directory is ready. Scripts can be run. Now to download and unzip FormMail...
"
ssh -t $USERNAME@$IPADDRESS 'wget -O ~/apps/'$APPNAME'/cgi-bin/formmail.zip http://www.scriptarchive.com/scripts/formmail/formmail.zip && unzip ~/apps/'$APPNAME'/cgi-bin/formmail.zip -d ~/apps/'$APPNAME'/cgi-bin/ && rm ~/apps/'$APPNAME'/cgi-bin/formmail.zip && chmod 755 ~/apps/'${APPNAME}'/cgi-bin/formmail/FormMail.pl'
echo -e "
FormMail is installed. Now to configure FormMail...
"
ssh -t $USERNAME@$IPADDRESS 'sed -i "s/scriptarchive.com/'${DOMAIN}"','"${RECIPIENTDOMAIN}'/g" ~/apps/'${APPNAME}'/cgi-bin/formmail/FormMail.pl && sed -i "s/72.52.156.109/'${IPADDRESS}'/g" ~/apps/'${APPNAME}'/cgi-bin/formmail/FormMail.pl'
echo -e "
FormMail is configured to allow mail to be sent to recipients $DOMAIN, $RECIPIENTDOMAIN and/or $IPADDRESS.
"
echo -e "
Creating an example page...
"
ssh -t $USERNAME@$IPADDRESS 'wget -O ~/apps/'${APPNAME}'/public/formmail-test.html https://raw.githubusercontent.com/JayHoltslander/FormMail-for-ServerPilot/master/formmail-test.html'
echo -e "
Example page created.
"
echo -e "
Configuring the form on the example form page...
"
ssh -t $USERNAME@$IPADDRESS 'sed -i "s/RECIPIENTHERE/'${RECIPIENT}'@'${RECIPIENTDOMAIN}'/g" ~/apps/'${APPNAME}'/public/formmail-test.html && sed -i "s/FORMMAILURLHERE/https:\/\/'${DOMAIN}'\/cgi-bin\/formmail\/FormMail.pl/g" ~/apps/'${APPNAME}'/public/formmail-test.html'

open https://$DOMAIN/formmail-test.html
else
	echo -e "${NC}
Cancelled
"
fi
