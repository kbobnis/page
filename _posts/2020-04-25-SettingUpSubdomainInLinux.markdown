---
layout: post
title: "Configuring VPS for wordpress on subdomains"
date: 2020-04-25 10:36:00 +0100
categories: server
---

## Setup that is being described

I have a Virtual Private Server with OVH, a `VPS 2018 SSD 1` plan. Software there is Debian  GNU/Linux 8 (jessie, this can be checked by typing ` cat /etc/*release`), Hardware: 1 vCore, 2GB, 20GB.

## Setting up domain or subdomain

I needed to create three subdomains and one domain for my bobnis.eu site.
- bobnis.eu -> homepage with my projects
- blog.bobnis.eu -> my blog
- m.bobnis.eu -> portfolio of my wife
- juliana.bobnis.eu -> portfolio of my sister


### DNS `A record` 

First would be to create a set of A records in my domain DNS records pointing the subdomain to my server ip. 

![](/assets/vps.png)

### Apache configuration

Then I needed to create sites-available config files for each page (remember to always add .conf at the end of the file name). 
```
/etc/apache2/sites-available/blog.bobnis.eu.config
```
with
```
  <VirtualHost *:80>
    ServerName  blog.bobnis.eu
    DocumentRoot /var/www/pages/blog.bobnis.eu
  </VirtualHost>
```

Then run `a2ensite blog.bobnis.eu.conf` to enable this site 

Then run `/etc/init.d/apache2 restart` to restart apache and apply the change.

Then checked my site: `blog.bobnis.eu` in browser

If it won't work for some reason, I check the configuration with two commands that often say what is wrong: `apachectl -S` and `sudo apache2ctl configtest`.

I did the same steps for all subdomains.

## How to work with permissions in /var/www

I know i will have many subdomains, as root user I created a directory per each domain and subdomain I will have in `/var/www/pages`. I changed owner to my user (kbobnis) and group to www-data user to it by running `sudo chown kbobnis:www-data /var/www/pages/<every_dir>`. 

I also have added a GUID bit so that every child file and directory will have the same group by `sudo chmod g+s bobnis.eu`

This game me permissions that look like this: 
```
kbobnis@vps820803:/var/www/pages$ ls -alh
drwxr-sr-x 6 kbobnis  www-data 4.0K Apr 25 18:29 bobnis.eu
```

The parts I am looking at is the 
- `drwxr-sr-x`
	- `d` says it is a directory
	- first tripe `rwx` says that the owner has read write and execute permissions
	- second triple `r-s` says that the group has read permissions and GUID bit enabled
	- third triple `r-x` says that everyone ran read and execute
- `kbobnis  www-data` this is the owner and the group of
- `bobnis.eu` this is the name of this directory

### Cloning a git repository with a website

I have a website bobnis.eu as a git repository. I want to be able to clone this repo in my web server, add it as my main domain (bobnis.eu) and show in browser.

To be able to git clone from private repo i need to either:
- add ssh keys to github to my current user
- use login / passs

I prefer the ssh keys, because my github password is long and I dont want to look for it everytime i will need to commit new changes that i make there.

So, ssh keys will be used.

I have created ssh key pair (public and private keys) and placed them
- `/home/kbobnis/.ssh/github_id_rsa` - private key
- `/home/kbobnis/.ssh/github_id_rsa.pub` - public key

I have copied the content text of public key and added it to github SSH keys and named it vps github.

Now for git clone.

I entered bobnis.eu `cd bobnis.eu` and run `git clone <my_repo url> .` and i got an error
```
kbobnis@vps820803:/var/www/bobnis.eu$ git clone git@github.com:kbobnis/bobnis.eu.git .
Cloning into '.'...
The authenticity of host 'github.com (140.82.118.3)' can't be established.
RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,140.82.118.3' (RSA) to the list of known hosts.
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

It says that it couldn't read my ssh keys. I had to create a config file with the names of my ssh keys so that the system can fetch them

I have entered my home .ssh dir `/home/kbobnis/.ssh/` and create a `config` file with contents

```
IdentityFile ~/.ssh/github_id_rsa
```

Then I run git clone and it went well.

### Page was not displaying 

In my web browser i go to bobnis.eu, but no page is displaying, it shows: 
```
This page isn’t working bobnis.eu is currently unable to handle this request.
HTTP ERROR 500
```

It could be that some permissions to log directories are not set properly. I needed to find apache logs and see this Error 500 entry log.

I navigated to `/etc/apache2` and had a look there:

```
kbobnis@vps820803:/etc/apache2$ ls
apache2.conf    conf-enabled  magic           mods-enabled  sites-available
conf-available  envvars       mods-available  ports.conf    sites-enabled
```

I thought the log location could be defined in apache2.conf file. inside I saw a line:

`ErrorLog ${APACHE_LOG_DIR}/error.log`

I found out that On Debian ${APACHE_LOG_DIR} is defined as /var/log/apache2 by default. I found the error.log there with line:

```
[Sat Apr 25 17:42:12.310032 2020] [:error] [pid 24047] [client 217.97.79.59:12669] PHP Warning:  require_once(/var/www/bobnis.eu/../../../frameworks/yii-1.1.17/framework/yii.php): fail
[Sat Apr 25 17:42:12.310309 2020] [:error] [pid 24047] [client 217.97.79.59:12669] PHP Fatal error:  require_once(): Failed opening required '/var/www/bobnis.eu/../../../frameworks/yii
~
```

It means that the yii framework that my site uses could not be found at that location.

I have created a new dir: /var/www/frameworks/yii and cloned the yii framework there

`git clone git@github.com:yiisoft/yii.git 1.1.23`

and added a soft link to it named current. 

`ln 1.1.23 current -s`

Now my framework dir looked like this:

```
kbobnis@vps820803:/var/www/frameworks/yii$ ls -alh
total 12K
drwxr-sr-x  3 kbobnis www-data 4.0K Apr 25 18:00 .
drwxr-sr-x  3 kbobnis www-data 4.0K Apr 25 17:58 ..
drwxr-sr-x 10 kbobnis www-data 4.0K Apr 25 17:58 1.1.23
lrwxrwxrwx  1 kbobnis www-data    6 Apr 25 18:00 current -> 1.1.23
```

Now I needed to update the path that bobnis.eu is looking for

so I navigated to 

`/var/www/bobnis.eu/index.php` 

and I saw a line there:
`$yii=dirname(__FILE__).'/../../../frameworks/yii-1.1.17/framework/yii.php';`

changed it to : 

`$yii='/var/www/frameworks/yii/current/framework/yii.php';`

Now I saw an exception in web browser instead of http error 500. 

```
CException
Application runtime path "/var/www/bobnis.eu/protected/runtime" is not valid. Please make sure it is a directory writable by the Web server process
```

i can see that the runtime is NOT writable by www-data group

```
kbobnis@vps820803:/var/www/bobnis.eu/protected/runtime$ ls -alh
total 16K
drwxr-sr-x 2 kbobnis www-data 4.0K Apr 25 17:42 .
drwxr-sr-x 8 kbobnis www-data 4.0K Apr 25 17:42 ..
-rw-r--r-- 1 kbobnis www-data 7.1K Apr 25 17:42 application.log
```

all i have to do is 

```
 chmod g+w runtime/
```

And it is working now:
```
kbobnis@vps820803:/var/www/bobnis.eu/protected$ ls -alh runtime
total 16K
drwxrwsr-x 2 kbobnis www-data 4.0K Apr 25 17:42 .
drwxr-sr-x 8 kbobnis www-data 4.0K Apr 25 17:42 ..
-rw-r--r-- 1 kbobnis www-data 7.1K Apr 25 17:42 application.log
```

And now my web page is showing properly at bobnis.eu

### VIM settings 

I use VIM and with default settings I have to always set `:syntax on` and `:set nowrap`. 

I needed to create a .vimrc file in my home directory and put there 

```
syntax on
set nowrap
```

Now when I open vim and the syntax is automatically on.

### Setting up another wordpress site

On my previous VPS i had several wordpress sites set up.

I have used a free wordpress plugin called UpdrawftPlus - Backup/Restore to backup all sites to my google drive.

Now I needed to set up empty wordpress sites on my VPS and restore from those backups.

First was be juliana.bobnis.eu. 

I have downloaded wordpress files from https://github.com/WordPress/WordPress to 
`/var/www/frameworks/wordpress`

I have copied wordpress files from `/var/www/frameworks/wordpress` -> `/var/www/pages/juliana.bobnis.eu`

I have entered juliana.bobnis.eu/wp-login.php and a wordpress first install page showed up. It was asking me for database name, username, password, database host and table prefix.

I have ordered my vps with one wordpress installation preinstalled, so I used that info i received from them there. I will be using the same database for several wordpress instances, to I changed the table prefix there to wp_juliana (the same db prefix I used in my original wordpress) for my juliana.bobnis.eu site. 
 
After I filled those, I got a message that `Unable to write to wp-config.php file.`
I checked permissions for this directory and see that the group can not in fact modify the directory and there can not create any new files
```
drwxr-xr-x  5 kbobnis www-data 4.0K Apr 25 20:01 .
```

The . is permission on the current directory I was in right now.

So, I added permission to write by the www-data group by `sudo chmod g+w .` I went back in history in the web page and forward and now it says all is good. I created a user and wordpress starts for me.

Now I wanted to install the backup plugin on the new site and restore from my backed up copy on google drive. 


### Wordpress is asking for FTP user to install a plugin.

I don't have a ftp user.

I found out that wordpress will only ask for FTP credentials when it won't have permissions to write by itself. So I entered the directory where wordpress holds plugins: <wordpress>/wp-content/plugins and added write permissions for www-group for this whole directory. 

I went to wordpress and tried to install plugin, but it still asks me for FTP credentials.

I added `define('FS_METHOD','direct');` at the end of wp-config.php file and this time it worked.

### Recovering previously backed up continued

I have restored my previous wordpress site using this UpdraftPlus plugin, but after it finished, my wordpress instead of showing the page, shows: 
`You appear to have already installed WordPress. To reinstall please clear your old database tables first.`

So I have removed the whole wordpress files, created new, downloaded the plugin again and now put a different wp tables prefix when asked for it. And now it worked.


### Different site show when i type bobnis.eu and www.bobnis.eu

When I type bobnis.eu, my homepage shows up. This is my preferred behaviour.

When I type www.bobnis.eu, my blog.bobnis.eu shows up.

Let's try pinging and see what we get there.

```
$ ping bobnis.eu

Pinging bobnis.eu [51.210.6.251] with 32 bytes of data:
Reply from 51.210.6.251: bytes=32 time=32ms TTL=49
```

and 

```
$ ping www.bobnis.eu

Pinging www.bobnis.eu [51.210.6.251] with 32 bytes of data:
Reply from 51.210.6.251: bytes=32 time=32ms TTL=49
```

At least I know that both of those are getting to the same server.

Now my apache configuration. The `/etc/apache2/sites-enabled` directory.

The file `/etc/apache2/sites-enabled/blog.bobnis.eu.conf` shows:
```
<VirtualHost *:80>
        ServerName blog.bobnis.eu

        DocumentRoot /var/www/pages/blog.bobnis.eu
</VirtualHost>
```

The file `/etc/apache2/sites-enabled/bobnis.eu.conf` shows:
```
<VirtualHost *:80>
        ServerName bobnis.eu

        DocumentRoot /var/www/pages/bobnis.eu
</VirtualHost>
```

This looks good. I don't know why it is redirecting to blog.bobnis.eu when I type www.bobnis.eu in the browser, but I will figure it out another time. 


