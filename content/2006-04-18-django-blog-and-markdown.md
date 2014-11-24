title: Django Blog and Markdown
category: Python
tags: django, python
summary: As I mentioned previously, I wanted to edit my posts in Markdown. I had
    played with Markdown both in Python and Django before, so it was a rather
    simple addition, but I wanted it to work without hiccups on different
    systems with varying needs. Therefore I can up with the following 'markdown'
    filter:

As I mentioned previously, I wanted to edit my posts in Markdown. I had played with Markdown both in Python and Django before, so it was a rather simple addition, but I wanted it to work without hiccups on different systems with varying needs. Therefore I can up with the following 'markdown' filter:

    def markdown(value, arg=''):
        try:
            import markdown
        except ImportError:
            from django.utils.html import escape, linebreaks
            return linebreaks(escape(value))
        else:
            if arg == 'footnotes':
                return markdown.markdownWithFootnotes(value)
            else:
                return markdown.markdown(value)
        
    register.filter('markdown', markdown)

First, if the Python markdown lib is not installed, generating and ImportError, the 'escape' and 'linebreaks' filters are used instead. That way, if you're using the app on a system without markdown, you'll just have to use html on the source text for entries. If markdown later becomes available, it leaves html alone, so there shouldn't be any problems to speak of.

When Markdown is available and imports without incident, then we check whether the the footnote extension should be used. I realize I could have just included the footnote extension by default, but it was easy enough to add the flexibility and give template authors the option. In the template just do:

    {% raw %}{{ post.body|markdown:"footnotes" }}{% endraw %}

If you don't want footnotes, then remove the "footnote" argument:

    {% raw %}{{ post.body|markdown }}{% endraw %}

One could easily add options for different extensions. Of course, this would only allow for one extension at a time, but considering that only three extensions are officially listed (one written by myself) besides the included footnotes extension, that's not much of an issue. With just a little more code, I could easily allow the argument to be a list of extensions, but I'll worry about that when there are enough extensions to merit such code.
