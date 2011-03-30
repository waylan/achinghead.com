---
layout: post
title: "Firewalls: the Good, the Bad and the Ugly"
author: Waylan Limberg
categories: "security"
summary: "Don't get me wrong, firewalls are great. They block all sorts of unwanted crap. Here at work I understand the firewall was blocking thousands of Blasterworm hits a day at the height of that little episode. Not once have we  been affected by such attacks. Considering that everyone uses IE, Outlook and various older versions of Windows, that's saying something."
---

Don't get me wrong, firewalls are great. They block all sorts of unwanted crap. Here at work I understand the firewall was blocking thousands of Blasterworm hits a day at the height of that little episode. Not once have we  been affected by such attacks. Considering that everyone uses IE, Outlook and various older versions of Windows, that's saying something.

The bad part is when someone other that myself implements the firewall. They may at times block legitimate things that I need/want to accomplish as part of my job. If I haven't mentioned it before, I work for county government, which has its pluses and minuses. Being a small county, all the various departments and branches of government share the same building and network. Some of us in the Judicial branch have actually been restricted from accessing resources provided by the state to carry out our job. As we don't run the network, it is rather bothersome to get those permissions changed. Oh, sure, people jump when the presiding judge calls, but we shouldn't have to resort to that.

Actually, we haven't, but its come close once or twice. I think the craziest thing I ever encountered was when trying to download a printer driver. The first thing I did was go straight to the manufacturer's web site and locate the proper driver their. However, when I attempted to download the file I was informed that the request was blocked because the file was from an unknown source. What? Lexmark is an unknown source? Then why did we buy equipment from them? To top it off, I decided to try one of those driver repositories where anyone can upload files and claim they are driver's for product X. The site even has big red letters warning that the files may not be what they say they are. After a few short minutes, I had the driver I wanted and my printer problems were reduced. (No, they weren't completely solved, but that is another matter entirely. Fortunetely I no longer have that printer.) Where's the unknown source here?

The ugly? As of this morning, when trying to view any XHTML page served as content type: "application/xhtml+xml" I get the following message:

<blockquote>WatchGuard firewall: Response denied from http://XX.XX.XX.XXX:80/: Unsafe content type "application/xhtml+xml"</blockquote>

Now, for those who don't know, XHTML is supposed to be served as such, not 'text/html', or even 'text/xml' for that matter. (I would post a link to an article explaining why but I am at work right now and every page that supposedly contains such content seems to be blocked so I can't actually verify that they actually contain said content.) Now, seeing as I am just viewing web pages, not running obscure applications, this would be no problem. However, that is just the thing; basic, valid web pages that have no executable applications are being blocked. Why, much of the <a href='http://www.w3.com/'>W3C</a>'s site is no longer available to me. Is that site now considered malicious? For crying out loud!

<h3>Update</h3>
After a little Googling I found a few sites with some helpful info regarding content types. Here they are for reference purposes.

<ul>
<li><a href="http://ppewww.ph.gla.ac.uk/~flavell/www/content-type.html">The Content-type Saga</a></li>
<li><a href="http://www.utoronto.ca/ian/books/html4ed/appb/mimetype.html">Multipart Internet Mail Extensions (MIME)</a></li>
<li><a href="http://www.google.com/search?q=content+type&sourceid=mozilla-search&start=0&start=0&ie=utf-8&oe=utf-8">More Google results...</a></li>
</ul>

<h3>Update Again</h3>
It's about 4:30 p.m., some 6 hours later, and the problem seems to have disappeared. I wonder if the admin checked the log and fixed it or if it was just one of those crazy things. Either way, I have settled down. And, to think that I didn't even need to make a request. I will now be able to sleep tonight.