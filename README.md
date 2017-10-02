#### Wordpresser - Wordpress installation using Nginx, Virtual Hosts, WP-CLI and Saltstack  
  
##### Installs a LEMP server using Saltstack

- Installs Nginx from Nginx's repository - [Nginx Installation Link](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)
- Installs MySQL (5.5) on Debian-based OSes and Mariadb on RedHat-based OSes
- Install PHP (PHP 5.6), and PHP-FPM, and copies a default info.php file to Nginx's default Document Root (/usr/share/nginx/html/)
- Edits `php.ini` and `www.conf`
- Configures Nginx's default configuration file (default.conf) to use PHP and PHP-FPM
- *changes SELinux to permissive on CentOS/RedHat variants*

##### Wordpress Installation

- Creates a new username (under `/home`)
- Creates the necessary sub-directories under the user's home-directory (`logs`, `public_html`)
- Creates a virtual host (under Nginx) for the new user
- Downloads and installs `wpcli` (system-wide)
- Uses `wpcli` to downloads and install Wordpress under `/home/{username}/public_html`

##### Examples used

Domain-Name: ***wptest.com***  
Username: ***wptest***  
Document-Root: ***/home/wptest/public_html***  

##### Usage

- Setup the top.sls file with the minions' names/hostnames
- Copy the pillar file over to the pillar location
- Run `salt '*' state.apply`
- Edit the local `hosts` file to point the test domain (`wptest.com` in this case) to the Minion's IP

##### Expected output

- Accessing the domain (`wptest.com`) on the browser, using the minion's IP should yield a default Wordpress website.
- Accessing the Admin page (`wptest.com/wp-admin`) should allow you to log in using the WP credentials (`admin/test123`)
  
**Tested on:** Debian 8, Debian 9, CentOS 7  
**TODO:**  Test on Ubuntu variants
