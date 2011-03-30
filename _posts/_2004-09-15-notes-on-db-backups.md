---
layout: post
title: "Notes on DB Backups"
author: Waylan Limberg
categories: "miscellaneous "
summary: "I needed to back up my DB, but my host wasn't very helpful. Here's why, and how I got it all to work."
---

Taking a lesson <a href='http://achinghead.com/throb/index.php?p=2' title="the site's back up">from last time</a>, I figured I should finally back up my database. Ok, actually it was long overdo. But that was the point, unlike last time (probably no more than 5 posts with maybe two of them worth saving) I have alot of stuff to lose here. How to do it?

I recalled that the control panel my host provides, gives me access to phpMyAdmin. Hey, that has an export feature. Problem is, when I tried it, phpMyAdmin refused to open giving me some generic error message indicating that I was using an invalid password. Hmm, it never even asked for one. At the time, I really didn't have time to mess around with my host's Help Desk so I forgot about it. 

Then, a few days later, I found a <a href='http://weblogtoolscollection.com/index.php?p=88&more=1&c=1' title="Now restore and backup in the same script!">Backup & Restore Hack/Plugin</a>.  Now that is handy! I can back up from a cron job (my host actually allows these) or manually from the WP admin page. One problem though. The script calls mysqldump from the shell. Ouch! My host does not allow such functionality.

So off to the Help Desk I went. First off, they couldn't even answer the question I asked. Then, after clarifying (unnecessarily, IMO) they said, sorry, they can't help. But if the permissions are messed up, I may want to delete the DB and create a new one. Say What?! The DB is working fine. I just want to back it up. What good would that do?

After contemplating my options for a few short minutes, I decided it wouldn't be to hard to write my own little script, once I figured out how to get the table info. Just step through the tables and run a 'SELECT *' query on them all. But before diving in I checked <a href='http://freshmeat.net/search/?q=mysql+backup&section=projects&Go.x=6&Go.y=12' title="Freashmeat.net Search Results">Freshmeat</a> and found a number of scripts that already do that. In fact, a few describe themselves as being replacements for mysqldump when that is not an option. After looking at those that didn't require logging in to some other download site, I settled on <a href='http://freshmeat.net/projects/phpmysqlbackupro/' title="MySQL Backup Pro - Default branch">MySQL Backup Pro</a> which, I'm happy to say, worked great. Now, with my data backed up, I created a new, empty DB and restored the data to the new DB, then deleted the old one after pointing WP to the new one. After checking that everything was in order, I then (finally) upgraded WP to v1.2, which allows real plugins, some of which will be necessary for my soon to be released revision of this here blog. Maybe I should switch hosts first? Either way, its working now.
