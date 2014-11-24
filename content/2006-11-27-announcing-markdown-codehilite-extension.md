title: Announcing The Markdown CodeHilite Extension
category: Markdown
tags: markdown, python
summary: The Markdown CodeHilite Extension adds code/syntax highlighting to
    standard Python-Markdown code blocks using one of three highlighting
    engines: GNU Enscript, dp.SyntaxHighlighter and Pygments. [Check it
    out](http://achinghead.com/markdown/codehilite/) or keep reading to see how
    it all came about.

Finally, after many code variations and internal debates over syntax highlighting engines, I am happy to announce that Version 0.1 of the [Python-Markdown][] CodeHilite Extension has been released. You can read all about it and download it from the [official page][]. 

[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/
[official page]: http://achinghead.com/markdown/codehilite/

I know that some time ago an extension was released that highlighted Python code. However, that extension introduced a new syntax for identifying code blocks (wrapped in brackets [ ]), only worked with Python code, and seems to no longer be available  online. The third problem aside, I wanted to do better. In fact, when that extension was released I already had a working prototype that at that time also only worked with python code. The difference was that mine used regular (indented) code blocks. Unfortunately, at that time, I was sub-classing the `Markdown` class (overriding the `_processCodeBlock()` function). It worked, but was not ideal and certainly didn't play nice with other extensions[^1]. Therefore, I have kept silent until now.

At some point after that I was able to get working code that called [GNU Enscript][] from the command line. While not the most ideal solution, it would be something that most any *nix system would have available. At that time I devised the syntax for identifying the language of a code block which draws heavily from shebang lines. The 'colon' syntax came from the fact that Markdown originally used two or more colons at the beginning of each line to identify code blocks. It seemed only natural to build on that.

[GNU Enscript]: http://www.codento.com/people/mtr/genscript/

Then, Yuri released Markdown 1.6 which considerably changed the way extensions were implemented. But then I read this statement in the revised documentation:

> Preprocessors, patterns and postprocessors need to then be wrapped together into an extension, which should be implemented as a class that extends markdown.Extension and should over-ride the extendMarkdown() method. extendMarkdown() is called during markdown construction, giving the extension a pointer to the markdown object (the md parameters) and markdown's global variables (md_globals), which in theory gives the extension an option of changing anything it cares to change. However, what it really should be doing is inserting preprocessors, postprocessors and patterns into the markdown pipeline:

The part that caught my eye was that the extension was 'given a pointer to the markdown object', "which in theory gives the extension an option of changing anything it cares to change. " Sure enough, `extendMarkdown()` is passed `md` which is, as far as I can tell, the equivalent of `self` within an instance of `Markdown()`. As everything is an object in Python, I was easily able to replace/override the `_processCodeBlock()` function with my own. This one line (within `extendMarkdown()`) did the trick:

    :::python
    md._processCodeBlock = _hiliteCodeBlock

Just like that, I had a viable solution. I threw in a few configuration settings and was ready to release, with one problem. While Enscript may be a great fall back when nothing else is available, it's not an ideal solution IMHO.

I recalled that [Paul Bisex][] had used a javascript solution ([dp.SyntaxHighlighter][]) in the first implementation of his [paste-bin][]. While viable, for reasons I shouldn't need to state here, I wouldn't want it to be an only solution. Then, as I'm about to give it a go anyway, Paul goes and [changes][] his paste-bin to use [Pygments][]. Wow, just what I was looking for! Thanks Paul.

[Paul Bisex]: http://e-scribe.com/news/
[dp.SyntaxHighlighter]: http://www.dreamprojections.com/syntaxhighlighter/Default.aspx
[paste-bin]: http://e-scribe.com/news/247
[changes]: http://e-scribe.com/news/299
[Pygments]: http://pygments.pocoo.org/

Thus, the CodeHilite extension was born as you know it. I left Enscript support as a fall-back just in case. I left dp.SyntaxHighlighter in for those who want to offer non-highlighted code for all there code blocks in addition to the 'pretty code' (The only real advantage of a client-side solution IMO). And I set Pygments as the default engine. Overall, I'm pretty happy with how things turned out.

[^1]: Other extensions would have needed to extend my new sub-class rather that the `Markdown` class. Is would be ridiculous to except other extension authors to build in such support. For that matter, I had no desire to do as much for my [other][] extension.

[other]: http://achinghead.com/markdown/wikilink/