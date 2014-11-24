title: Adding WikiLinks to Markdown in Python
category: Markdown
tags: markdown, python
summary: I needed Markdown to be extended to support wikilinks. It just so happens
    that the <a
    href='http://www.freewisdom.org/projects/python-markdown/'>markdown lib for
    python</a> makes this easy. After only a little head scratching I was able
    to come up with the following...

__Update:__ For the latest on this see the [page][] I created.

[page]: http://achinghead.com/markdown/wikilink/

I've been playing with <a href='http://www.djangoproject.com/'>Django</a> lately and really like it. I've wanted to create some sort of paging system where I can create new pages and easily edit their content. Basically a cross between a wiki and Wordpress pages. Django seemed like the easiest way for me to do this. Add to that, I really prefer <a href='http://daringfireball.net/projects/markdown/syntax'>Markdown syntax</a> to any other such markup language.
 
It was with this in mind that I took a look at <a href='http://e-scribe.com/news/'>Paul Bissex</a>'s <a href='http://e-scribe.com/news/171'>wikiproject</a>. The basics are certainly there. And with little effort, I was able to get Markdown, along with the basic wikilinks working. The problem was that the wikilink code had no way of knowing to skip over various parts of the Markdown syntax. That means that Markdown needs to be extended to support wikilinks. It just so happens that the <a href='http://www.freewisdom.org/projects/python-markdown/'>markdown lib for python</a> makes this easy. After only a little head scratching I was able to come up with the following code:
 
    #!python
    import markdown

    class WikiLinks (markdown.BasePattern) :
      def handleMatch(self, m, doc) :
        WIKI_URL = '/'+m.group(2)+'/'
        WIKI_LABEL = m.group(2)
        a = doc.createElement('a')
        a.appendChild(doc.createTextNode(WIKI_LABEL))
        a.setAttribute('href', WIKI_URL)
        a.setAttribute('class', 'wikilink')
        return a


    def wikiMarkdown (text) :
      WIKILINK_RE = r'\b(([A-Z]+[a-z]+){2,})\b'
      md = markdown.Markdown()
      md.inlinePatterns.append(WikiLinks(WIKILINK_RE))
      md.source = text
      return str(md)

I should note that the above code is in no way connected to Django. It should be easily adapted to work for any python project. It is also possible that the URL and LABEL would need to be further manipulated for your projects needs. This shouldn't be to difficult either. But let's get the basics working first. So, how about a quick test?:

    :::pycon
    >>> text = ```Some text with a WikiLink.
    ...
    ... And a <a href=`http://example.com/RealLink`>RealLink</a>.
    ...
    ... And a [MarkdownLink](/MarkdownLink/ "A MarkdownLink") for completeness.```
    ...
    >>> print wikiMarkdown(text)

    <p>Some text with a <a href="/WikiLink/" class="wikilink">WikiLink</a>.
    </p>
    <p>And a <a href=`http://example.com/RealLink`> <a href="/RealLink/" class="wikilink">RealLink</a> </a>.
    </p>
    <p>And a <a href="/MarkdownLink/" title="A MarkdownLink">MarkdownLink</a> for completeness.
    </p>

Now, my understanding is that markdown is supposed to leave HTML alone. However, that doesn't quite happen here as evidenced by the "RealLink". Whether this is a problem with my code or a bug in python's markdown  lib I don't know. Either way, I did a bunch more tests, but this seems to be the only problem I could find. That, and I need a way to escape CamelCase words that I do not want WikiLinked (like PhD...). In the end, I decided that in reality, I would rather explicitly mark each link as such and never have to worry about inadvertent links sneaking into my text. With markdown, creating links is easy enough, and with Markdown's referenced links, the text is plenty easy to read as source. So, in the end, I have decided to not use the above code. That being said, someone else may find it useful.
 
If you would like to use my code, consider it licensed the same as Markdown in Python (dual-licensed under <a href='http://www.gnu.org/copyleft/gpl.html'>GPL</a> and <a href='http://www.opensource.org/licenses/bsd-license.php'>BSD License</a> - no, I didn't really put much thought into that). You can download the source as <a href='/code/wikiMarkdown.py'>wikiMarkdown.py</a>. Copy the file to a directory in your PYTHONPATH and do the following (assuming you have Markdown in Python installed and working):
 
    :::pycon
    >>> from wikiMarkdown import *
    >>> wm = wikiMarkdown(YOURTEXTSOURCE)

Happy wikilinking with Markdown!