---
layout: post
title: "target is back! - maybe"
author: Waylan Limberg
categories: "css"
summary: "The <a href='http://webstandards.org/'>Web Standards Project</a> announced some <a href='http://webstandards.org/buzz/archive/2004_02.html#a000301'>CSS Spec Updates</a> yesterday. Among them was the <a href='http://www.w3.org/TR/2004/WD-css3-hyperlinks-20040224/'>CSS3 Hyperlink Presentation Module</a>. If you recall, the &#39;target&#39; attribute was depreciated with xhtml (causing xhtml strict to fail validation), thereby forcing one to use JavaScript to open a link anywhere but the current window/tab of the browser. This &quot;first working draft&quot; proposes the addition of the &#39;target&#39; property to CSS3 and is even fully aware of tabbed browsing as found in modern browsers.  For instance, a designer/developer (or whatever you call them/us) could cause a link to open in a new tab directly in front of the current tab in the users' browser with the following CSS&#58;"
---

The <a href='http://webstandards.org/'>Web Standards Project</a> announced some <a href='http://webstandards.org/buzz/archive/2004_02.html#a000301'>CSS Spec Updates</a> yesterday. Among them was the <a href='http://www.w3.org/TR/2004/WD-css3-hyperlinks-20040224/'>CSS3 Hyperlink Presentation Module</a>. If you recall, the &#39;target&#39; attribute was depreciated with xhtml (causing xhtml strict to fail validation), thereby forcing one to use JavaScript to open a link anywhere but the current window/tab of the browser. This &quot;first working draft&quot; proposes the addition of the &#39;target&#39; property to CSS3 and is even fully aware of tabbed browsing as found in modern browsers.  For instance, a designer/developer (or whatever you call them/us) could cause a link to open in a new tab directly in front of the current tab in the users' browser with the following CSS&#58;

    a {target: new tab above;}

Or maybe the designer/developer would like the link to open in a new window behind all open windows on the users' desktop. No problem&#58;

    a {target: new window back;}

They have even included easy ways to reference other frames in the current browser window/tab (not that I would use them &#45; I try NOT to use frames).

How cool is that!? But let's not get too excited yet. It is only the &quot;first working draft&quot;. It still needs to get through all the red tape to become a final recommendation and even then we will need to wait for browsers to support it. And at the rate some browsers comply with standards, that will take awhile. The only plus is that any complying browsers would respond as intended while non-compliant browsers <em>should</em> (and I stress should) just ignore the property and open the link in the current window as they do today.

On a similar note, the <a href='http://www.w3.org/TR/2004/WD-css3-reader-20040224/'>CSS &#39;reader&#39; Media Type first working draft</a> was also published. It's nice to see the <a href='http://www.w3c.org'>W3C</a> addressing problems with current screen reading techniques. As the announcement mentions, this was all, or at least mostly, because <a href='http://joeclark.org/access/?ALA'>Joe Clark</a> <a href='http://lists.w3.org/Archives/Public/www-style/2003Oct/0328.html'>proposed</a> such a rule and wrote about it at <a href='http://www.alistapart.com/articles/fir/'>ala</a>. Now that is pretty cool. Way to go Joe!

On an unrelated note, you should now be able to read this without straining your eyes as I adjusted the font used. I worked on a few color changes last night but kept running into a wall with the main nav bar. However, I did determine that the blocks in the side bar should not be so bold. (They were designed <del>in their current state</del> outside of the context of this site). <del>Once I have the color scheme complete you should see it here.</del>