---
layout: post
title: "Recreating RPG Module page"
date: 2020-05-05 00:36:00 +0100
categories: server
---

I have a mobile game: RPG Module, [https://play.google.com/store/apps/details?id=com.wyspianStudios.rpgModule](https://play.google.com/store/apps/details?id=com.wyspianStudios.rpgModule)

![](/assets/rpg_module.png)

Within this game I redirect to the game homepage: [http://bobnis.eu/rpg-module](http://bobnis.eu/rpg-module)

Unfortunately I migrated my VPS to another server and forgot about this site. 

![](/assets/bobnis_eu_rpg_module.png)

I need to create this page again so that the link in my game will not be broken.

## Introduction

I load my ssh keys into pageant, login using putty and have my terminal open and ready. 

![](/assets/terminal.png)

On my server I have a directory structure under /var/www/pages:
```
kbobnis@vps820803:/var/www/pages$ ls -alh
total 24K
drwxr-sr-x 6 kbobnis  www-data 4.0K Apr 26 08:55 .
drwxr-xr-x 4 www-data www-data 4.0K Apr 25 18:39 ..
drwxr-sr-x 5 kbobnis  www-data 4.0K Apr 20 21:53 blog.bobnis.eu
drwxr-sr-x 6 kbobnis  www-data 4.0K Apr 25 18:29 bobnis.eu
drwxr-sr-x 6 kbobnis  www-data 4.0K Apr 25 23:19 juliana.bobnis.eu
drwxrwsr-x 6 kbobnis  www-data 4.0K Apr 26 09:03 m.bobnis.eu
```

I want to create a subdomain: rpg-module.bobnis.eu but also redirect from http://bobnis.eu/rpg-module into it.

## Creating new subdomain


### Creating a directory structure for the subdomain 

I am copying the wordpress files from my clean wordpress instalation to a fresh directory 
```
kbobnis@vps820803:/var/www/pages$ cp ../frameworks/wordpress rpg-module.bobnis.eu -R
```

This copy takes about 45 seconds on my cheapest VPS and then it freezes, I am closing the putty session and creating a new one. The freeze gets me worried, so I check the current CPU usage with `htop` command.

![](/assets/htop.png)

All looks good, ram usage is only 299/1962MB, CPU usage is 0.5%.

Then I need to check if owner, group and permissions are set up properly. I want the owner to be my user (kbobnis), group to be www-data and permissions to be writable by owner, readable by group but in some cases writable. Those cases include:
- the root directory of the wordpress. To create the wp-config.php file during installation process. 
- the /wp-content/plugins directory for the wordpress to be able to install plugins by itself

### Adding apache configuration files for new subdomain

I go to `/etc/apache2/sites-available` create a copy of one of my config files and rename it to `rpg-module.bobnis.eu.conf`. I do this with sudo, because this directory can only be writable by root user.

```
kbobnis@vps820803:/etc/apache2/sites-available$ sudo cp blog.bobnis.eu.conf rpg-module.bobnis.eu.conf
[sudo] password for kbobnis:
kbobnis@vps820803:/etc/apache2/sites-available$ ls -alh
total 36K
drwxr-xr-x 2 root root 4.0K May  5 11:05 .
drwxr-xr-x 8 root root 4.0K Apr 26 17:25 ..
-rw-r--r-- 1 root root  114 Apr 25 22:06 blog.bobnis.eu.conf
-rw-r--r-- 1 root root  104 Apr 25 18:40 bobnis.eu.conf
-rw-r--r-- 1 root root 6.3K Apr 25 14:32 default-ssl.conf
-rw-r--r-- 1 root root  120 Apr 25 18:41 juliana.bobnis.eu.conf
-rw-r--r-- 1 root root  108 Apr 25 18:42 m.bobnis.eu.conf
-rw-r--r-- 1 root root  114 May  5 11:05 rpg-module.bobnis.eu.conf
```

Now I modify the rpg-module.bobnis.eu.conf to have proper values.

I want to redirect the `bobnis.eu/rpg-module` request into this subdomain, so I try a few methods and will check witch, if any will work. 

```
<VirtualHost *:80>
        ServerName rpg-module.bobnis.eu

        ServerAlias www.rpg-module.bobnis.eu
        ServerAlias bobnis.eu/rpg-module

        RewriteEngine On
        RewriteRule "bobnis.eu/rpg-module" "^(/rpg-module/.*)"

        ServerPath "/rpg-module"

        DocumentRoot /var/www/pages/rpg-module.bobnis.eu
</VirtualHost>
```

Then I enable this subdomain with 

```
kbobnis@vps820803:/etc/apache2/sites-available$ sudo a2ensite rpg-module.bobnis.eu.conf
Enabling site rpg-module.bobnis.eu.
To activate the new configuration, you need to run:
  service apache2 reload
```

So I run this service apache2 reload with sudo. 

### Creating DNS redirections for my subdomain

I need to create a `rpg-module.bobnis.eu` A record in my DNS config panel for `bobnis.eu` domain.

![](/assets/dns_a_record.png)

I got a notification `The modification will be applied immediately on the DNS zone, but bear in mind the propagation time (maximum 24 hrs).`

I check if this works, and sure enough, when I type `rpg-module.bobnis.eu` in browser i get a familiar wordpress installation page. It works.

![](/assets/wordpress_installation_page.png)

### Preparing wordpress for first time use

I open my VPS installation email and copy values to already created wordpress database. All is good, after few seconds wordpress is installed and ready to use.

### Redirecting bobnis.eu/rpg-module to rpg-module.bobnis.eu

Even though I have put many aliases and redirects in my apache config files, when I type `bobnis.eu/rpg-module` i still get an empty site.

The second thing I try is to create a link in bobnis.eu site redirecting to rpg-module.bobnis.eu. 
```
kbobnis@vps820803:/var/www/pages/bobnis.eu$ ln ../rpg-module.bobnis.eu rpg-module -s
```

And it works.

Now when I enter `bobnis.eu/rpg-module` i see my `rpg-module.bobnis.eu` page.

### Redirecting bobnis.eu/rpg-module to rpg-module.bobnis.eu part 2

The solution above didn't satisfy me. The url was still `bobnis.eu/rpg-module`. I wanted a redirection to happen so that the user will see `rpg-module.bobnis.eu` address.

To do this, I have created a directory `/var/www/pages/bobnis.eu/rpg-module` in this directory i have created a .htaccess file with contents:

```
RewriteEngine On

RewriteCond %{bobnis.eu}  ^bobnis\.eu\/rpg-module [NC]
RewriteRule ^ rpg-module.bobnis.eu [R=302,L]
```

And added 