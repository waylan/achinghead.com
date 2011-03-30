---
layout: post
title: "inline dropdowns"
author: Waylan Limberg
categories: "css"
summary: "I came up with this last week. I seem to remember first seeing this effect in some flash sites and then a few DHTML sites. It occurred to me that this might just be possible with xhtml and css only. At least in standards compliant browsers. Sure enough, I was right. After getting it to work I stopped by <a href='http://www.maxdesign.com.au/about.cfm' title=\"Russ Weakly Bio\">Russ Weakly</a>'s<a href='http://css.maxdesign.com.au/listamatic2/index.htm' title=\"nested list options\">listamatic2</a> and found that a <a href='http://css.maxdesign.com.au/listamatic2/horizontal02.htm' title=\"Blue's clues\">few</a> <a href='http://css.maxdesign.com.au/listamatic2/horizontal05.htm' title=\"Horizontal in horizontal\">others</a> have done similar things. The difference here is that the second level only appears on rollover. With just a few minor adjustments to the css one could easily have this work the same as the listamatic examples."
---

I came up with this last week. I seem to remember first seeing this effect in some flash sites and then a few DHTML sites. It occurred to me that this might just be possible with xhtml and css only. At least in standards compliant browsers. Sure enough, I was right. After getting it to work I stopped by <a href='http://www.maxdesign.com.au/about.cfm' title="Russ Weakly Bio">Russ Weakly</a>'s<a href='http://css.maxdesign.com.au/listamatic2/index.htm' title="nested list options">listamatic2</a> and found that a <a href='http://css.maxdesign.com.au/listamatic2/horizontal02.htm' title="Blue's clues">few</a> <a href='http://css.maxdesign.com.au/listamatic2/horizontal05.htm' title="Horizontal in horizontal">others</a> have done similar things. The difference here is that the second level only appears on rollover. With just a few minor adjustments to the css one could easily have this work the same as the listamatic examples.

I use a simple nested unordered list and this css:

    ul#nav {
        list-style:none;
        float:left; 
        width:100%; 
        position:relative; 
        margin:0; 
        padding:0 0 1em 0;
    }
    #nav li {
        float:left; 
        padding: 0 .5em;
    }
    #nav li ul {
        list-style:none; 
        visibility: hidden; 
        position:absolute; 
        top:1em; 
        left:0; 
        padding:0; 
        margin:0;
    }
    #nav li:hover {
        background:silver
    }
    #nav li:hover ul {
        visibility: visible; 
        background:silver;
    }
                            

View a <a href="http://achinghead.com/inlinedropdown-unstyled.html" title="Inline Dropdown Menu - Unstyled">simple example here</a>.

Have any suggestions? Could you test it in other browsers? Maybe even provide some screenshots? How about some better looking menus? You will be credited for anything you submit. All submissions subject to my approval.