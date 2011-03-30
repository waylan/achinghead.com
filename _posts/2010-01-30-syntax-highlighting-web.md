---
layout: post
title: "Syntax Highlighting on the Web"
author: Waylan Limberg
categories: "css, html, markdown, python, syntax highlighting"
summary: "The state of Syntax highlighting on the web, why I think JavaScript highlighting libraries make more sense than server side solutions and how that relates to Markdown."
---

Years ago I starting using [Markdown][] to markup text on this site. And
as is often the case today, I would include various code snippets in my posts. I
wanted those snippets to be highlighted like I saw on others sites (mostly
[Trac][] instances at the time) and whatever text editor I may have been using.
As I soon learned, this is a [problem][] that many people have had various
levels of success with for some time.

### The Background

Of course, Trac was written in [Python][] and I like working with Python so I
thought I'd dig in and see if I could borrow from their code. It is a open
source project after all. Well, after a few false starts trying to piece
together their code, I finally came across something (not in the code itself)
that told me they were using a third part package which name escapes me now. The
package had horrible documentation and a little searching confirmed that most
people had as little success getting it to work as I did. I believe Trac has
since abandoned that package for a newer one which had not yet been released
when this was all going on.

This lack of a good syntax highlighter for Python sent me on a search through
various possible solutions. In the course of that search, I learned a lot and
much of my opinions discussed below are drawn from that experience. I should
also note that the second [Python-Markdown][] extension I ever released [^1]
was the [CodeHilite][] extension. In it's earliest form it called a command
line script which is available on most any Linux distributions and extracted and
slightly modified a snippet of html from the returned result do be included in a
Markdown document. It worked, but each snippet in a blog post would generate
another call to an external process and slow rendering down that much more.

I looked at other solutions in various other languages and almost switched back
to PHP for some of the nice libraries offered in that language (i.e.:
[GeSHi][]). I also looked at Ruby, but it was brand new at the time and didn't
have much in the way of third party libraries.[^2] I also found an interesting
JavaScript project called dp.SyntaxHighlighter. It had a few quirks, so I
wasn't sold on it, but I did see it's value so I built my extension with a
setting to either use the command line script or to spit out the wonky html
necessary for the JavaScript library to work (I believe it required a specially
classed or otherwise labeled textarea). Then, almost immediately after I
released my first version of the Python-Markdown extension, I came across the
newly released [Pygments][] library. I almost immediately added Pygments as a
third highlighting option and soon thereafter abandoned the others, leaving
Pygments as the sole highlighting library. A short time later, I was asked to
join the Python-Markdown project and didn't spend much time on syntax
highlighting for quite a while.

Before finding Pygments, I looked at starting my own library among other
things. At the time a syntax parser was a <del>little</del> <ins>lot</ins> over
my head, but I did find many examples that highlighted Python code. I even got
my own variation working with little trouble. If I recall correctly, it was the
first backend I built for my extension. However, I abandoned it before public 
release as it is one thing to get Python to tokenize Python code[^3], but quite
another to get it to tokenize anything else. At the time I was writing more
about HTML/CSS than about Python, so this was a non-option.

### Numbering Lines

Another issue besides tokenizing the code into its various parts (keywords,
variables, integers, strings, comments, etc.), is line numbering. Some may argue
that this is an unnecessary feature, but try reading a tutorial as a beginner
about how to understand some snippet of code, and if the author doesn't have an
easy way to indicate which line in the code he's talking about, you could easily
get lost. Besides, it makes it easy for commenters to point to the exact error
they found in your code (Hey, it's not my fault you didn't test the code you're
writing about).

Even today it's not uncommon to find lines of code broken up into table rows.
One row per line of code, with two columns, the first being the line number and
the second containing the actual code. With proper styling it looks nice, but
now try to select the code to copy and past into your editor. Oops, you got the
line numbers as well. Now you have to go back and delete the line number, the
punctuation following it (usually a period) and any white space added in without
messing up indentation and the like. The same problem presents itself with a
standard ordered list. Fortunately, that was solved a long time ago by
[Dan Loda][], [Simon Willison][] (both via the Way Back Machine), and
[Dustan Orchard][] (scroll about half-way down that page). The trick is to style
your `<ol>` so that the line numbers are displayed but don't get copied.

Interestingly, modern highlighters such as Pygments still have not solved this
problem. Pygments specifically still uses a table, of only one row and two
columns. The first column contains all the line numbers with line breaks in a
single cell and the second column contains all the lines of code, again with
line breaks in a single cell. Assuming your styling is correct, the line
numbers in the first column should line up with the corresponding lines in
column two. Unfortunately, I have seen many sites where this is broken.
Strangely, it seems to be more of a problem on longer snippets, so the site
designer probably didn't catch it on his short test examples while adjusting
the styling to fit his site. On some very long snippets, the line numbers
actually end short of the number of lines. While, this allows one to select and
copy the code within one table cell and avoid getting line numbers, it simply is
not an acceptable solution. Someone really should write a new formatter for
Pygments that uses the much better ordered-list.

One of the downsides of the ordered-list solution to line numbering is that if
the client has CSS turned off, the user will still get line numbers when
copying and pasting. But, how often does a user have CSS turned off and
JavaScript still on? I would guess not often enough to be a concern. Today a
number of JavaScript libraries exist which do the syntax highlighting and line
numbering themselves -- no server side code needed. So, in cases where CSS and 
JavaScript are disabled, the JavaScript will never run and the code blocks will
remain in their plain, unadulterated state ready for copying and pasting line
number free.

### The Un-Styled Source

But there is something else interesting about Dustan Orchard's solution. Even
if the line numbers were still a problem when it came to copying and pasting, a
link is provided to download each snippet as a separate file in its original
plain text form -- no line numbers anywhere. Unfortunately, for Dustan this
means each snippet needs to be in a separate file on his server. His code then
parses the post and finds each instance of his custom markup, determines where
the source file is, reads it from the file system, and inserts it into his HTML
line by line before sereving it. Not ideal. Besides, I am working with Markdown
where the snippets are inline with the body of text and simply marked as code
blocks according to Markdown's syntax. How am I going to serve each snippet
separately, especially when I have multiple snippets in one document. I'm sure
it's possible, but not really worth the effort in my opinion.

I suppose one could include two copies of the snippet in the HTML document; one
styled and one not. Then with a little JavaScript, the user could toggle back
and forth between the two. But if your using JavaScript, there's a better
option. 

Consider the project that I believe started life as that wonky
dp.SyntaxHighlighter library I spoke of earlier: [SyntaxHighlighter][]. I
realize the link goes to an old abandoned version of the project, but go take a
look at the sample provided in the summary there. Notice the extra links at the
top of the screen capture? If it wasn't just an image, clicking on them would
reveal that they are links, one of which gives you the option to "view plain"
code. The [newer version][] of the project gives you the same option as a little
pop-up when you hover your mouse over the block of code, as does the
[jQuery plugin][] adaptation of the library which actually outputs valid HTML.
Personally, I like the old styling better, but that should be customizable.

The point is that this is only possible with JavaScript. As the server is
sending the document with the plain code wrapped in `<pre>` and/or `<code>`
tags, the code will display fine in browsers with CSS and/or JavaScript turned
off. However, with JavaScript enabled, we get the pretty version. However, as
we already have the original plain text version available client-side, its easy
to have JavaScript open a little pop-up window that displays the plain-text
code. While pop-ups are generally to be avoided, they are only used here when
specifically activated by the end user and they serve a useful purpose in this
context. I would imagine the end user could think that the plain code has
actually been fetched from the server as a separate file like Dustan Orchard's 
site does. Except, the code displays instantaneously without the delay of a
request. And there's no dance involved in including two versions and figuring
out which one to display and which one to hide by default. I suspect that's why
at least one such JavaScript library ([Highlight.js][]) markets itself as
working specifically with Markdown.

### The State of JavaScript Libraries

Like the server-side libraries, many of these JavaScript libraries accept
patches for additional languages or even have a mechanism for adding your own
extensions ([SHJS][] provides an interesting solution for this). Really, you
have little to loose and much to gain by using them. A quick Google search
turned up this [list of nine][] JavaScript libraries currently out there (not
counting SHJS mentioned earlier). Unfortunately, it appears that only two of
those ([Lighter.js][] and [Chili][]) actually have solved the
line-numbers-in-copy-and-paste problem. Actually, most of them don't even
support line numbering, but those that do all have a solution of one kind or
another.[^4] The worst part is, all of the libraries that generate line numbers
are jQuery or MooTools extensions. I'd really like a standalone solution that
actually output valid HTML (that last bit disqualifies SyntaxHighlighter).

Another problem is that each of those JavaScript libraries uses a slightly
different syntax to determine what code blocks are to be highlighted and what
language to highlight them as. In other words, a library like Markdown can't
just output all its code blocks using one format and expect it to work with any
JavaScript syntax highlighting library. And that's a problem.

### The Sad Conclusion

Something that may seem to be missing from this analysis is a good look at
libraries in languages other than Python and JavaScript. While that may be worth
doing, it's beside the point really. Suppose you find a good library in language
X, but are forced to develop a project in language Y (perhaps due to
client/employer demands). Now that library is rather useless -- unless that
library happens to be in JavaScript and is not a plugin for a specific
JavaScript framework you also happen not to be using on this particular project.
I simply used the state of Python libraries above as examples
because that is what I am most familiar with. However, I have experienced the
same usability problems and annoyances on various sites developed on all sorts
of platforms. While we have come a long way, it is evident that we still have a
long way to go.

So, yes, I think JavaScript libraries for syntax highlighting on the web are
the way of the future. I don't expect to be putting much effort into
server-side solutions from here-on-out. Any efforts will be directed primarily
at the client-side offerings out there. Hopefully we can make them better.

[Markdown]: http://daringfireball.net/projects/markdown/
[Trac]: http://trac.edgewall.org/
[problem]: http://web.archive.org/web/20030407072903/http://www.paranoidfish.org/notes/2003/03/17/1845
[Python]: http://python.org
[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/
[CodeHilite]: http://www.freewisdom.org/projects/python-markdown/CodeHilite
[GeSHi]: http://qbnz.com/highlighter/index.php
[Pygments]: http://pygments.org/
[Dan Loda]: http://web.archive.org/web/20021006003116/webweaver.org/dan/css/corners/with_borders.html
[Simon Willison]: http://web.archive.org/web/20021021220639/http://development.incutio.com/simon/numbered-code-experiment.html
[Dustan Orchard]: http://www.1976design.com/blog/archive/2004/07/29/redesign-tag-transform/
[SyntaxHighlighter]: http://code.google.com/p/syntaxhighlighter/
[newer version]: http://alexgorbatchev.com/wiki/SyntaxHighlighter
[jQuery plugin]: http://startbigthinksmall.wordpress.com/2008/10/30/beautyofcode-jquery-plugin-for-syntax-highlighting/
[Highlight.js]: http://softwaremaniacs.org/soft/highlight/en/
[SHJS]: http://shjs.sourceforge.net/
[list of nine]: http://www.webdesignbooth.com/9-useful-javascript-syntax-highlighting-scripts/
[Lighter.js]: http://pradador.com/code/lighterjs/
[Chili]: http://code.google.com/p/jquery-chili-js/
[Ultraviolet]: http://ultraviolet.rubyforge.org/
[ColourCode]: http://22bits.exofire.net/browse/code/colourcode
[first extension]: http://www.freewisdom.org/projects/python-markdown/WikiLinks
[google-code-prettify]: http://code.google.com/p/google-code-prettify/
[FAQs]: http://google-code-prettify.googlecode.com/svn/trunk/README.html

[^1]: The [first extension][] I released publicly was a simple little thing
    that converted WikiLinks to links. It simply served as a means to better
    understand Python-Markdown's extension API. I had actually started the core
    of my highlighting extension before the wikilink extension was thought of.

[^2]: Ruby has since gained a few libraries since then. Two being
    [Ultraviolet][] and [ColourCode][], both of which I know nothing about.

[^3]: For those who don't know, the Python tokenizer is callable from Python
    code. It will return a list of tokens which you can easily iterate over and
    build a bunch of appropriately styled spans for syntax highlighted Python
    code on the web.

[^4]: Actually that is not entirely true. For example, while Google's own
    library ([google-code-prettify][]) does not directly support line numbers,
    they suggest a rather lousy workaround on their [FAQs][] page (second to
    last FAQ). Ugh.
