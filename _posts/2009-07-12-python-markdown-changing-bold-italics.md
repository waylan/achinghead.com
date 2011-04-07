---
layout: post
title: "Python-Markdown Tutorial Part 2: Changing Bold and Italics"
author: Waylan Limberg
categories: "markdown, python"
summary: "Part 2 is a series of tutorials which step through creating a simple Python-Markdown Extension that slightly alters the Markdown syntax. Specifically, in this part, we redefine the \"bold\" and \"italics\" syntax, overriding the parsers current behavior."
---

In [part 1][], we created a Python-Markdown extension which implements a new 
syntax for defining `<ins>` and `<del>` tags. Now we need to alter Markdown's 
existing syntax for bold and italics. As a reminder, your new syntax should 
look like this:

    :::no-highlight
    Two hyphens for --delete--.
    Two underscores for __insert__.
    Two asterisks for **strong**.
    Two slashes for //emphasis//.

First, we need to define our new regular expressions. We can just use the same
expressions from last time with a few modifications.

    :::python
    STRONG_RE = r'(\*\*)(.*?)\*\*'
    EMPH_RE = r'(\/\/)(.*?)\/\/'

Now we need to insert these into the markdown parser. However, unlike with ins and del, we need to override the existing inline patterns. A quick look at the
[source][] indicates that strong and emphasis are currently implemented with 
four inline patterns; "strong", "emphasis", "emphasis2" and "strong_em".

Let's override "strong" first.

    :::python
    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            ...
            # Create new strong pattern
            strong_tag = markdown.inlinepatterns.SimpleTagPattern(STRONG_RE, 'strong')
            # Override existing strong pattern
            md.inlinepatterns['strong'] = strong_tag

Notice that rather than "add"ing a new pattern before or after an existing 
pattern, we simple reassigned the value of a pattern named "strong". This is
because the old pattern named "strong" already existed and we don't need to 
change its location in the parser. So we simply assign a new pattern instance 
to it.

We can do the same for emphasis:

    :::python
    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            ...
            emph_tag = markdown.inlinepatterns.SimpleTagPattern(EMPH_RE, 'emphasis')
            md.inlinepatterns['emphasis'] = emph_tag

Now we have two old patterns left, "strong_em" and "emphasis2". "Emphasis2"
was just a special case so that underscored_words were not mistaken for 
emphasis, but as our new syntax required double underscores, it's not needed any
more. Therefore, we can delete it. The same applies for strong_em. With the old 
syntax, due to both strong and emphasis using the same characters, a special 
case was needed to match the two nested together (i.e.: `***like this***`). 
Again this isn't needed. We can delete the two in the same way we would delete 
dict items:

    :::python
    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            ...
            del md.inlinepatterns['strong_em']
            del md.inlinepatterns['emphasis2']

That should do it. For completeness, the entire extension should look like this:

    :::python
    import markdown

    DEL_RE = r'(--)(.*?)--'
    INS_RE = r'(__)(.*?)__'
    STRONG_RE = r'(\*\*)(.*?)\*\*'
    EMPH_RE = r'(\/\/)(.*?)\/\/'

    class MyExtension(markdown.Extension):
        def extendMarkdown(self, md, md_globals):
            del_tag = markdown.inlinepatterns.SimpleTagPattern(DEL_RE, 'del')
            md.inlinepatterns.add('del', del_tag, '>not_strong')
            ins_tag = markdown.inlinepatterns.SimpleTagPattern(INS_RE, 'ins')
            md.inlinepatterns.add('ins', ins_tag, '>del')
            strong_tag = markdown.inlinepatterns.SimpleTagPattern(STRONG_RE, 'strong')
            md.inlinepatterns['strong'] = strong_tag
            emph_tag = markdown.inlinepatterns.SimpleTagPattern(EMPH_RE, 'emphasis')
            md.inlinepatterns['emphasis'] = emph_tag
            del md.inlinepatterns['strong_em']
            del md.inlinepatterns['emphasis2']

    def makeExtension(configs=None):
        return MyExtension(configs=configs)

In part 3 (coming soon) we'll combine all four of those patterns into one new
pattern. Yes, that means we'll be writing our own InlinePattern class.

[part 1]: /python-markdown-adding-insert-delete.html
[source]: http://gitorious.org/python-markdown/mainline/blobs/master/markdown/__init__.py#line276

