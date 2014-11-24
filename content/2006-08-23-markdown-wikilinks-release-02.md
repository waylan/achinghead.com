title: Markdown WikiLinks Release 0.2
category: Markdown
tags: markdown, python
summary: I've made some improvements to my WikiLink extension for Python-Markdown.
    And added a page for it.

Some time ago I released my [first stab][] at an extension for [Python-Markdown][]. As I said then, I didn't really have any use for it, but it did give me a chance to play with Markdown. To continue that exercise and better understand how best to create extensions for Markdown, I made some improvements to the extension.

[first stab]: http://achinghead.com/archives/67/adding-wikilinks-to-markdown-in-python/
[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/

The most obvious problem with my first try was that if one wanted to use the extension with other extensions (in other words; not just calling the provided wrapper function), then the regex would need to be redefined. That is not ideal. After looking at the footnote extension (included with markdown) I realized I needed to define a class which registered the extension. Then one could just create an instance of that class and continue. Brilliant!

To view the new code and see how it all works, I'll point you to the [new page][] I created just for the extension. Any additional updates will be made there. And for those that may be interested, I'll announce any major updates here, although I don't anticipate many. That being said, A new and improved way of including extensions was recently [announced][] on the mailing list. I suppose I'll be playing with that soon.

[new page]: http://achinghead.com/markdown/wikilink/
[announced]: http://sourceforge.net/mailarchive/forum.php?thread_id=29904824&forum_id=48941