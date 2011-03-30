---
layout: post
title: "K2 with Django"
author: Waylan Limberg
categories: "django, python"
summary: "Some time ago, [Jay Skabber](http://jay.skabber.com/wordpress/) stated that [his blog](http://socialistsoftware.com/post/socialist-software-now-powered-django)  was powered by [Django](http://djangoproject.com), and used [K2](http://getk2.com) templates converted to Django's template format. Of course, any one could see at a quick glance that he was using his own styles in place of the default K2 styles. In the spirit of the [CSS Zen Garden](http://www.csszengarden.com/), this is part of the beauty of K2. A sound html base is provided that any designer can build upon making it necessary to only provide a new style sheet and images to get a very difference looking site."
---

**Note** I first drafted this entry over a month ago and there have been a number of changes to the original source upon which I am building here. Therefore, some of my concerns are not all that relevant. I think it's still interesting nonetheless.

Some time ago, [Jay Skabber](http://jay.skabber.com/wordpress/) stated that [his blog](http://socialistsoftware.com/post/socialist-software-now-powered-django)  was powered by [Django](http://djangoproject.com), and used [K2](http://getk2.com) templates converted to Django's template format. Of course, any one could see at a quick glance that he was using his own styles in place of the default K2 styles. In the spirit of the [CSS Zen Garden](http://www.csszengarden.com/), this is part of the beauty of K2. A sound html base is provided that any designer can build upon making it necessary to only provide a new style sheet and images to get a very difference looking site.

After [getting a copy](http://source.socialistsoftware.com/sssource/) installed and running on my local test box, the first thing I did was replace Jay's style sheet with the default for K2 along with the necessary images and **Presto!** just like that, I was looking at K2.

Unfortunately there were a few problems. I should mention that I started with revision 6 and Jay has made a few updates since then. It became immediately apparent that there were some glaring validation warnings. A quick perusal through the code easily cleaned them up. As an example, Jay had inserted the main body text of a post like this:

    {% raw %}<p>{{ post.body|escape|linebreaks }}</p>{% endraw %}

The fact that he was using the `linebreaks` filter should be a dead giveaway as to what the problem was. `Linebreaks` wraps each newline in `<p>` tags. However, you can't wrap a bunch of paragraphs in another paragraph. Removing those `<p>` tags from the template solved the issue easily enough.

While looking at the template files, it came to my attention that there were various blocks of code that Jay had commented out as he was not using them. While not a problem in itself, they were statically rendered in the template without the proper data being provided dynamicly. As an example, wrong trackback links were being given in the html source among other such unused services. While everything looks good to the human reader, robots could easily become confused. Therefore, I removed such sections of code. I also completely removed the code for Digg and Technorati, as I have no interest in using either.

Another obvious difference is that K2 uses relative dates while Jay used exact dates formatted to his preferences. Personally, I like the relative dates. As Django already provides the `timesince` filter, this was easy as pie to change. All I had to do was replace the `date` filter and format with a call to `timesince` and add the word "ago" after the date to create a proper English sentence. For kicks, you can get the exact date by hovering over the relative date on the single post page. 

While I was playing with dates, I figured I'd use relative dates for the comments as well[^1]. However, I didn't care how long ago the comment was made, but rather, how long after the blog entry was first posted that the comment was added. Upon looking at the code in `django/utils/timesince.py` I discovered that there is a little wrapper function `timeuntil()`, that calls `timesince()` with the start and end dates switched. For some reason there is no filter for `timeuntil`. Of course, creating one would be easy enough, but that doesn't quite do what I wanted. However, I realized that the same principle could easily be used in another filter which passed along both the date and time the blog entry was posted and the date and time of the comment. Thus, the `timebetween` filter was born, which finds the time between any two dates.

    def timebetween(value, arg):
        'Formats a date as the time between two dates (i.e. "4 days, 6 hours")'
        from django.utils.timesince import timesince
        return timesince(value, arg)
    
    register.filter('timebetween', timebetween)

Call `timebetween` in the template like so:

    Posted {% raw %}{{ post.pub_date|timebetween:comment.submit_date }}{% endraw %} later.

That satisfied me enough to say I have a closer representation of the K2 templates. Of course, there are some glaring omissions such as no rss feeds for comments, no recent comments in the sidebar, no trackback/pingback support, and no archive pages by date. With the exception of the trackback/pingback support, everything should be simple enough to implement; however, it wasn't quite as high on my priority list as something else; namely Markdown. But that is another post for another time; as is how I'm getting my del.icio.us links.

[^1]: Yes, I realize that K2 does not use relative dates for the comments by default. However, I chose to add them to see how easy it would be. Besides, I like them better anyway. They have allot more meaning, especially when the date for the blog entry is in a relative format. It's that much more difficult to get a sense of the time that has gone by without an exact time on each end of the equation. Additionally, I didn't add in the author's name for each post, which seems redundant as I would be the only author on my own blog. No doubt Jay had similar reason's for omitting that bit of information as well.
