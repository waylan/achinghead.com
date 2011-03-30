---
layout: post
title: "thoughts on caching"
author: Waylan Limberg
categories: "miscellaneous "
summary: "I've been meaning to look into caching a little closer but, as usual, time is short. Then <a href=\"http://www.fiftyfoureleven.com/sandbox/weblog/2004/jul/caching-server-side-client-side/\" title=\"FiftyFourEleven.com\">Mike P.</a> Offers some links to some great resources on caching. Thanks for the links Mike."
---

I've been meaning to look into caching a little closer but, as usual, time is short. Then <a href="http://www.fiftyfoureleven.com/sandbox/weblog/2004/jul/caching-server-side-client-side/" title="FiftyFourEleven.com">Mike P.</a> Offers some links to some great resources on caching. Thanks for the links Mike.

While considering the possibilities, blogs always seemed like a easy system to cache at first, but on closer inspection get complicated. For most of us (who post once a day or less), all we need is a small script that creates a cached version immediately after the new post is added. That seems simple enough. Just add a little code to the end of the script that adds the post. But, what about user comments. Do we really want to recreate the cached page for every single comment. Not if there are alot of comments. I would think that that would only increase server load.

So here are a few ideas I have. One could have the page be partially cached and partially dynamic. In other words. The cached page could call a script (server-side of course) to load the comments dynamically. The problem with this is that, while load time is somewhat decreased, it still takes longer than may be desired. In some browsers (Opera?) the CSS is not loaded until the entire page is and this can look strange on a page that is slow to load.

So what to do? Then it occurred to me, maybe <a href='http://www.mezzoblue.com/' title="Mezzoblue.com">Dave Shea</a> is onto something. He displays comments on a separate page from the actual post. This way he could easily cache the post while leaving the comments page dynamic. But, then again, he does indicate how many comments have already been made  at the end of the post. It just may not be possible to create a completely static system after all.