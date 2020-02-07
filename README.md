# FormMail for ServerPilot
[![works badge](https://cdn.jsdelivr.net/gh/nikku/works-on-my-machine@v0.2.0/badge.svg)](https://github.com/nikku/works-on-my-machine)

You're now seconds away from working forms for your static html site.

This is a shell script for installing and configuring [FormMail v1.9.3](http://www.scriptarchive.com/formmail.html) on a [DigitalOcean](https://m.do.co/c/cb37830bf938) server that's been configured by [ServerPilot](https://www.serverpilot.io/?refcode=893765b37410) so that an App is able to send form submission emails. Great for static html sites that don't want to use php.

**Basically this is an automation of:**
* https://serverpilot.io/docs/how-to-create-a-cgi-bin-directory/
* http://www.scriptarchive.com/formmail.html

You run this script locally, give it the info it needs to connect and configure everything, it sets everything up and then gives you a starter/sample form to test mail delivery with.

**Important Notes:** 
* FormMail has had [vulnerabilities in the past](https://www.google.com/search?q=formmail+vulnerabilities). This script uses the newest version (v1.9.3)
  * You may want to rename your formmail folder and FormMail.pl script for some added security.
* This counts as a customization that could complicate/nullify your ServerPilot support options.


## Installing & Running
1. Make sure to ``chmod 755 install-formmail.sh`` the installer so it has the correct permissions required to run.
2. Run on your local machine with ``./install-formmail.sh``
3. Works best if you have SSH keys already set for your root user and for your ServerPilot user. [[Instructions](https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/)]

## Uninstalling.
1. Via SFTP, delete your ``cgi-bin`` folder and it's contents.
2. Via SFTP, delete your ``public/formmail-test.html`` file.
3. Via SSH (as root user), delete ``/etc/apache-sp/vhosts.d/[APPNAME].d/cgi-bin.conf``

### Relevant articles
* [FormMail's ReadMe](http://www.scriptarchive.com/readme/formmail.html)
* [FormMail's FAQ](http://www.scriptarchive.com/faq/formmail.html)
* [Configuring and Using FormMail](https://www.hostingmanual.net/configuring-using-formmail/)
* [Google search results](https://www.google.com/search?q=how+to+use+%22FormMail%22)
