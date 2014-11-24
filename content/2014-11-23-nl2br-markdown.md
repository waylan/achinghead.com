title: Newline-to-Break and Markdown
date: 2014-11-23
category: Markdown
tags: markdown


I've been giving a lot of thought lately to the behavior popularized by 
[GitHub Flavored Markdown][1] where all newlines result in breaks (`<br>`). I am
not suggesting that [Markdown][2] should change in any way, but I am trying to
clarify my opinion of the altered behavior (hereinafter 'nl2br') in certain
contexts.

In the past I have always been openly against nl2br. This has likely been
because I've mostly written Markdown text from the command line (in vim). Any vi
or Emacs users can likely understand my aversion to nl2br (For those who are
unaware, line wrapping in text editors is a fairly new feature that is still not
the default in "real" command line text editors). That said, I also
understand the usefulness of nl2br in something like blog comments. Many (most)
commenters may not even be intermediate Markdown users and all they know is that
what they type and what appears after they submit looks the same (perhaps with
the exception of the font, etc).[^1] So yes, in that context nl2br might make
sense.

Even when editing long Markdown documents within a textarea in a browser, there
are some annoyances. For example indenting becomes a chore if the site devs
didn't add some JavaScript to cause the tab key to type a tab character instead
of moving the cursor out of the textarea. And you'd better indent a long code
block in your editor (you do know how to indent multiple lines at once in your
editor don't you?) before copying and pasting into a Markdown code block unless
you like hitting the space (remember---no tab key) and arrow keys repeatedly.
But I digress. Textareas don't offer the option of showing whitespace characters
(like any good text editor does) and it becomes difficult to work out when a
line ends with two spaces or not. And if the page doesn't offer a preview---it
becomes almost impossible to get it right.

The point is, it seems to me that Markdown was created in a different era,
before people edited documents from within the browser. Therefore, *perhaps*
some of the more recent altered behaviors make more sense in today's world. This
has been something in the back of my mind lately. Perhaps the recent [spec][3]
written by J.M. has something to do with it as it addresses some of the
whitespace issues very [nicely][4].[^2]

However, in a discussion on a list for an unrelated code project, the developers
were considering a policy change to allow lines of code longer than 79 chars.
The idea was that almost no one uses command line editors anymore and it is silly
to restrict line length to 79 characters. It becomes a waste of screen real
estate and makes for some ugly code on occasion. The proposal was to lengthen
the maximum to the length of GitHub's code display box (120 I think). Well,
actually that length minus 1 so that diffs won't have to wrap when they add the
 `+` or `-` to the front of lines.

And that last bit got me thinking. Didn't I read someone say very recently that
one of the great things about Markdown is that is works really good with diff to
track changes (If it was you, sorry I forget where I read that)? I agree ...
*if* there are hard line breaks in the text. However, if the editors
line-wrapping feature is turned on (like all textareas and many modern editors)
and the author doesn't manually add hard line breaks, then diff doesn't work so
well.

And there's the rub.

What if the nl2br feature only worked on lines shorter than `n` chars long so
that we could have nl2br *and* pretty diffs? But what should `n` be? And what if
I want a hard break at char `n+1`? Or more specifically, what if the hard break
was at `n-1`, but then in a later edit to the beginning of the line, the end is
pushed out to `n+1` and I don't notice till much later? That seems like a
nonstarter to me.

And even if that problem could be avoided, we still have ugly diffs with
unwrapped lines. Should we require all lines to be hard wrapped? How would that
get enforced in a browser? And while vim has tools built in to automatically
reconfigure the hard wrapping when you make a edit to some line in the middle of
a paragraph, most modern test editors don't have that kind of feature---or at
least no one knows about it if they do.

It seems to me that while Markdown's ease of reading and writing has made it the
go-to markup language for writing HTML when you don't actually know HTML, it
actually makes a really lousy markup language for writing within a browser's
textarea. Perhaps that is why there seems to be a proliferation of native
markdown editor applications of late. But even they don't do hard line wrapping.

[1]: https://help.github.com/articles/github-flavored-markdown/
[2]: http://daringfireball.net/projects/markdown/syntax
[3]: http://spec.commonmark.org/
[4]: http://spec.commonmark.org/0.12/#example-490

[^1]: It is interesting that GitHub does not even include nl2br behavior in
their list of "[[d]ifferences from traditional
Markdown](https://help.github.com/articles/github-flavored-markdown/#differences-from-traditional-markdown)."

[^2]: While I agree that the [CommonMark Spec][3] does offer some nice syntax (perhaps
even better in a few cases), I do not consider CommonMark to be [Markdown][2].
Perhaps a step-sister. I realize that some of its creators have tried to call it
a 'better' Markdown, but I don't see it as Markdown at all. Personally, I would
have preferred that the creators had openly acknowledged it as not being
Markdown, which would have given them the freedom to leave behind some of the
uglier parties of Markdown's syntax. But that is a different subject for another
day.