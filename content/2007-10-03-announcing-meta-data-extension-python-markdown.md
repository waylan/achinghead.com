title: Announcing the Meta-Data Extension for Python-Markdown 
category: Markdown
tags: markdown, python
summary: I've just released a [Meta-Data Extension][meta] for
    [Python-Markdown][python]. I've also updated the [WikiLink][] and
    [Abbreviation][] extensions to support it. Here's how it came about.
    [meta]: http://achinghead.com/markdown/meta-data/
    [python]: http://www.freewisdom.org/projects/python-markdown/
    [Wikilink]: http://achinghead.com/markdown/wikilink/
    [Abbreviation]: http://achinghead.com/markdown/abbr/

I'm proud to announce the [Meta-Data Extension][meta] for [Python-Markdown][python].

[meta]: http://achinghead.com/markdown/meta-data/
[python]: http://www.freewisdom.org/projects/python-markdown/

I've [mentioned][] in the past my desire to build some sort of paging (wiki-like) system using Markdown. With a database, that's pretty easy, but for a simple file based system, there needs to be meta-data for each file. Information like 'Title', 'Summary', 'Author', 'Date', etc. [MultiMarkdown][] offers just such a solution with its [Meta-Data][] feature. Of course, MultiMarkdown is in perl, so I'd have to build my own in python.

It turns out that it's not to hard. I had ironed out the wrinkles of pre-processors with my [abbreviation][] extension, so I whipped up a solution in a few hours time. It probably would have been even less, but I had numerous interruptions. In any event, the extension simply extracts the data from the document and makes it available for use by other code. Perhaps someday I'll write an app that passes such data to a templating system.

Until then, it is very handy for configuring settings for various other extensions on a per document basis. Therefore, I have updated both the [abbreviation][] and [wikilink][] extensions to support the Meta-Data Extension. Read the [docs][] for all the details, or view the [code][] ([raw][]).

[mentioned]: http://achinghead.com/archive/67/adding-wikilinks-to-markdown-in-python/
[MultiMarkdown]: http://fletcherpenney.net/MultiMarkdown
[Meta-Data]: http://fletcherpenney.net/MultiMarkdown_Syntax_Guide#metadata
[abbreviation]: http://achinghead.com/markdown/abbr/
[wikilink]: http://achinghead.com/markdown/wikilink/
[docs]: http://achinghead.com/markdown/meta-data/
[code]: https://code.achinghead.com/browser/mdx/meta/trunk/mdx_meta.py
[raw]: https://code.achinghead.com/browser/mdx/meta/trunk/mdx_meta.py?format=raw