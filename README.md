# FormMail-for-ServerPilot

You're now seconds away from working forms for your static html site.

This is a shell script for installing and configuring [FormMail](http://www.scriptarchive.com/formmail.html) on a [DigitalOcean](https://m.do.co/c/cb37830bf938) server that's been configured by [ServerPilot](https://www.serverpilot.io/?refcode=893765b37410) so that an App is able to send form submission emails. Great for static html sites that don't want to use php.

**Basically this is an automation of:**
* https://serverpilot.io/docs/how-to-create-a-cgi-bin-directory/
* http://www.scriptarchive.com/formmail.html

You run this script, give it the info it needs to configure everything, it sets everything up and then gives you a starter/sample form to test mail delivery with.

**Note:** This counts as a customization that could complicate/nullify your ServerPilot support options.

## Uninstalling.
1. Via SFTP, delete your ``cgi-bin`` folder and it's contents.
2. Via SFTP, delete your ``public/formmail-test.html`` file.
3. Via SSH, delete ``/etc/apache-sp/vhosts.d/[APPNAME].d/cgi-bin.conf``

### Relevant articles
* [Configuring and Using FormMail](https://www.hostingmanual.net/configuring-using-formmail/)
* [Google search results](https://www.google.com/search?q=how+to+use+%22FormMail%22)
