---
layout: post
title: " Python-Markdown Tutorial Part 1: Adding InlinePatterns Insert and Delete"
author: Waylan Limberg
categories: "markdown, python"
summary: "A tutorial which steps through creating a simple Python-Markdown Extension which slightly alters the Markdown syntax. Specifically, we add an inline syntax for `<ins>` and `<del>`."
---

A [recent question][] on the [markdown-discuss][] mailing list resulted in some
suggestions for an extension to [Python-Markdown][]. I was able to point Simon
to the [documentation][] for writing extensions, but it occurs to me that that 
document could be a little overwhelming for a first-timer. Especially when all
he needs is to alter the behavior of a few inline patterns.

So, without further ado, I present a tutorial which steps through creating a
Python-Markdown Extension which incorporates something similar to Simon's
suggestion.

First, we need to establish the syntax we will be implementing. While Simon's 
suggestion would work as is, I'm more inclined to implement a slight variation
which follows the [prior art][] of the [txt2tags][] project. Interestingly, the
[CREOLE][] project more-or-less adopted this same syntax and has an interesting 
[explanation][] of the reasoning behind their community based decision. While I
may not agree with all their reasoning, I do like the idea that in each instance
double characters are used for markup. That way, there's less chance of a single
character needing to be escaped - both for the machine and human reader. So, the
syntax looks like this:

    :::no-highlight
    Two hyphens for --strike--.
    Two underscores for __underline__.
    Two asterisks for **bold**.
    Two slashes for //italic//.

The first step is to create the boilerplate code that will be required by any
Python-Markdown Extension.

    :::python
    import markdown

    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            # Insert code here to change markdown's behavior.
            pass

    def makeExtension(configs=None):
        return MyExtension(configs=configs)

Save the above code as `mdx_myextension.py`. Now, obviously, that code doesn't
really do anything useful, but now that we have it in place, we can actually 
start implementing our new syntax.

To start, let's implement the one part of that syntax that doesn't overlap with
Markdown's standard syntax; the `--strike--` syntax. I'm actually going to call 
it "del" (delete) rather than "strike" as the html generated will be the `<del>`
tag.

The first step is to write a regular expression to match the del syntax.

    :::python
    DEL_RE = r'(--)(.*?)--'

Now, there are probably a few things I should explain about that. First, you may
note that the first set of hyphens (`(--)`) are grouped in parentheses. This is 
because we will be using a generic pattern class provided by Python-Markdown.
Specifically, the `SimpleTextPattern` which expects the text content to be found
in `group(3)` of the regular expression. As the entire text (including markup)
will be in `group(1)`, we add the extra group to force the content we want into
`group(3)`.

Second, you may want to note that the content is matched using a non-greedy 
match `(.*?)`. Otherwise, everything between the first occurrence and the last 
would all be placed inside one `<del>` tag, which we do not want.

So, let's incorporate our regular expression into Markdown:

    :::python
    DEL_RE = r'(--)(.*?)--'
    
    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            # Create the del pattern
            del_tag = markdown.inlinepatterns.SimpleTagPattern(DEL_RE, 'del')
            # Insert del pattern into markdown parser
            md.inlinepatterns.add('del', del_tag, '>not_strong')

If you noticed, we added two lines. The first line creates an instance of a
`SimpleTagPattern`. This generic pattern class takes two arguments; the 
regular expression to match against (in this case `DEL_RE`), and the name of 
the tag to insert the text of `group(3)` into ("del").

The second line adds our new pattern to the Markdown parser. In the event that 
it is not obvious, the `extendMarkdown` method of any `markdown.Extension` class is passed two arguments; "md" and "md_globals". "md" is actually the instance
of the Markdown class. This allows you to alter anything you want in the class
from your extension. In this case, we are adding a new inline pattern named 
"del", using our pattern instance `del_tag` after the pattern named 
"not_strong" (thus the `'>not_strong'`).

Now let's test our new extension. Open a python interpreter in the same 
directory as you saved your file ("mdx_myextension.py") and try the following:

    :::python
    >>> import markdown
    >>> markdown.markdown('foo --deleted-- bar', ['myextension'])
    u'<p>foo <del>deleted</del> bar</p>'

Notice that we passed in "myextension" as an extension name. Markdown 
automatically appended "mdx_" to the name and tried to import it. As long as
the file is on your PYTHONPATH, Markdown will find it and load the extension.

Let's add our syntax for underline, or as I'm referring to it `__ins__` for the `<ins>` tag.

    :::python
    DEL_RE = r'(--)(.*?)--'
    INS_RE = r'(__)(.*?)__'
    
    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            del_tag = markdown.inlinepatterns.SimpleTagPattern(DEL_RE, 'del')
            md.inlinepatterns.add('del', del_tag, '>not_strong')
            ins_tag = markdown.inlinepatterns.SimpleTagPattern(INS_RE, 'ins')
            md.inlinepatterns.add('ins', ins_tag, '>del')

That should be self explanatory. We simply created a new pattern which matches
our "ins" syntax and added it after the "del" pattern. What's interesting about 
this is that we do not even need to alter the existing bold syntax (`__bold__`)
as our pattern has been inserted into the parser before the existing bold 
pattern (named "strong"). Therefore, by the time that the "strong" pattern gets
to run, our extension has already identified the double underscores as inserts,
so there's no match against the "strong" pattern.

Therefore, if all we wanted to implement was ins and del syntax we are done - 
well, except maybe giving it a decent name. Go ahead and test it out. That 
being the case, we'll stop here, and pick up with [Part 2][] <del>(coming soon)</del> where
we implement the new bold and italic syntax which replaces Markdown's 
existing syntax.

[recent question]: http://six.pairlist.net/pipermail/markdown-discuss/2009-June/001591.html
[markdown-discuss]: http://six.pairlist.net/mailman/listinfo/markdown-discuss
[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/
[documentation]: http://www.freewisdom.org/projects/python-markdown/Writing_Extensions
[prior art]: http://txt2tags.sourceforge.net/userguide/BoldItalicUnderlineStrike.html#6_5
[txt2tags]: http://txt2tags.sourceforge.net/index.html
[CREOLE]: http://www.wikicreole.org/
[explanation]: http://www.wikicreole.org/wiki/BoldAndItalicsReasoning
[Part 2]: /python-markdown-changing-bold-italics.html
