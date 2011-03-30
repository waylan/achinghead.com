---
layout: post
title: "ff centering bug?"
author: Waylan Limberg
categories: "css"
summary: "I resized the window to 800x600. Hmm, no problem here. In fact, the fixed width page seems to fit perfectly with no more than maybe a 5px margin on either side. How about 640x480? Aha, here the problem becomes apparent. The problem is that the scroll bar does not allow the user to scroll to the area that runs off the left side of the page."
---

In a <a href='http://www.37signals.com/svn/archives/000667.php' title="Razor Blade Rip Off">recent discussion</a> over at <a href='http://www.37signals.com/svn/' title="Signal vs. Noise">Signal vs. Noise</a>, an anonymous poster who calls himself 'Darrel' <a href='http://www.37signals.com/svn/archives/000667.php#darrel_024670' title="SvN Comment">complained</a> about a "centering bug" that causes a portion of the page to be off to the left of <a href='http://www.mozilla.org/products/firefox/' title="Mozilla Firefox Project">Firefox</a>'s viewport. I initially thought: "Duh, just scroll to the left." But, as he explains, the scroll bar is already all the way to the left and he cannot scroll left. Come to think of it, I have seen this before and always attributed it to poorly implemented code. Not the kind of thing you would expect from <a href='http://www.37signals.com/' title="37signals">Jason Fried and company</a>.

What really intrigued me was that I was also using Firefox and did not see the problem. It immediately occurred to me that 'Darrel' could very possibly be viewing the page with a smaller resolution. So I went up to the handy <a href='http://www.chrispederick.com/work/firefox/webdeveloper/' title="Web Developer Extension">Web Developer</a> toolbar and resized the window to 800x600. Hmm, no problem here. In fact, the fixed width page seems to fit perfectly with no more than maybe a 5px margin on either side. How about 640x480? Aha, here the problem becomes apparent (<a href='/throb/images/brokensvn.jpg' title="See the problem">view screenshot</a>).

After some additional resizing it seems that Firefox centers the page in the viewport regardless of the size of the viewport, which could arguably be considered more correct than certain other browsers which left justify the page when the viewport is not large enough to display the entire width of the page. (Whew, that's a long run-on!) The problem, as mentioned, is that the scroll bar does not allow the user to scroll to the area that runs off the left side of the page. A bug? Yes! But in SvN's CSS or in Firefox?

Whether there is a problem with Firefox or not, 'Darrel' provides a solution/workaround/hack. He suggests giving "BODY a min-width equal to the width of the [centered] wrapper DIV." So I fire up the <a href='http://editcss.mozdev.org/' title="Edit CSS Extension">Edit CSS</a> plugin and follow his advise. Sure enough, it works! (<a href='/throb/images/fixedsvn.jpg' title="See the solution">view screenshot</a>) The page is now left justified just like other browsers.

As he <a href='http://www.37signals.com/svn/archives/000667.php#darrel_024682' title="SvN Comment">later</a> points out, even a big name like <a href='http://www.macromedia.com/' title="Macromedia">Macromedia</a> has this problem. I think this can serve as a lesson. Just because you have a fixed width site doesn't mean you don't need to check your site in a smaller that intended viewport. You could inadvertently make it impossible for some users to access all the information on your site in their preferred browser.

<strong>Update</strong>
It appears that SvN has since corrected the problem. It seems they were not resizing the window far enough to detect it.