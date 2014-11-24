title: Marking up Code
date: 2012-05-31
modified: 2014-11-23
category: HTML
tags: html, syntax highlighting
Summary: There are as many different ways to mark up a code fragment in HTML as
    there are highlighting tools. Some use `pre` tags, some use 'code' tags,
    some use both, and then there are those that use other elements like `div`
    tags. Who's right? The HTML5 specification provides some very clear
    direction on the matter...

In reviewing syntax highlighters, I have observed that there are as many
different ways to mark up a code fragment in HTML as there are highlighting
tools. In other words, every tool seems to define a different syntax. Some use
`pre` tags, some use 'code' tags, some use both, and then there are those that
use other elements like `div` tags.

The most obvious problem with this is that if you want to switch to a different
tool, you need to change all your old HTML documents to use the new syntax;
which could be a real time suck. Sure the process could be automated, but
writing a bug-free script could become just as painful as making the changes
manually.

Another, perhaps less obvious issue is the semantics of the markup used. Does
the markup accurately convey what the content actually is? For example, many
people use `pre` tags around code. Of course, the `pre` element is specifically
for "preformatted text" which code often is. However, some have argued that
preformatted text is presentation, not semantics and therefore not the best
choice. Others have argued that the `code` element does nothing more than a
`span` under a different name and is therefore pointless. Some seem to subscribe
to both arguments and use other elements such as a `div` with a predefined class
of their choosing.
 
!!! note
    The content of this post was originally authored in March of 2011. It was
    then posted as a [Gist](https://gist.github.com/waylan/2844867) on May 31,
    2012. While the post wasn't added to this site until 2014, the May 31, 2012
    creation date has been preserved.

Who's right? Unfortunately, the HTML4 specification does little to clear up the
matter. Interestingly however, the working draft of the HTML5 specification
provides some very clear direction on the matter.

Let's look at the [`pre`][pre] element first. The basis definition of a `pre`
element is as follows:

> The `pre` element represents a block of preformatted text, in which structure
> is represented by typographic conventions rather than by elements.

Then, included in a list of example use cases in the specification is this item:

> - Including fragments of computer code, with structure indicated according to
>   the conventions of that language.

There is an important theme in those two fragments of the Specification.
Sometimes, the structure of text is determined by typographic conventions, not
by HTML elements. More importantly, computer code is specifically mentioned as
fitting that mold. For an example, consider Python. Unlike many languages,
white-space is significant in Python code. The line breaks and indentation mean
something. However, a language like JavaScript does not require any white-space
for the computer to understand it. Curly brackets and other such characters
define the meaning of the text. Of course, for all but the simplest of
JavaScript fragments to be human readable, they still need to be presented with
white-space.
    
Admittedly, after a code fragment has been passing through a syntax highlighter,
its structure is now represented by HTML elements. That being the case,
highlighted code may no longer belong in a `pre` tag. However, before such a
tool is used the HTML5 specification makes it pretty clear that a `pre` tag is
the appropriate way to go.

Finally, note this comment in the specification:

> To represent a block of computer code, the `pre` element can be used with a
> `code` element; ...

There are two things to note in that comment: (1) it is suggested that the `pre`
and `code` elements be used together, but (2) it is not a requirement (note the
use of "can" rather than "must" or "shall"), which begs the question; when do
you use one and when do you use both?
    
I think the [`code`][code] specification answers that for us. For starters:

> The `code` element represents a fragment of computer code. This could be an
> XML element name, a filename, a computer program, or any other string that a
> computer would recognize.

Interestingly, the word "represents" in that text in the specification links to
this [explanation][represents]:

> In the absence of style-layer rules to the contrary (e.g. author style
> sheets), user agents are expected to render an element so that it conveys to
> the user the meaning that the element __represents__, as described by this
> specification.

If the `code` element is to "represent" 'any string that a computer would
recognize' then it should be obvious that the `code` element is always required
when representing computer code. The `pre` element would only be used when that
computer code is "represented by typographic conventions rather than by
elements."

Perhaps the examples in the specification will clear this up.

> The following example shows how the element can be used in a paragraph to mark
> up element names and computer code, including punctuation.
>
>     :::html
>     <p>The <code>code</code> element represents a fragment of computer
>     code.</p>
> 
>     <p>When you call the <code>activate()</code> method on the
>     <code>robotSnowman</code> object, the eyes glow.</p>
>
>     <p>The example below uses the <code>begin</code> keyword to indicate
>     the start of a statement block. It is paired with an <code>end</code>
>     keyword, which is followed by the <code>.</code> punctuation character
>     (full stop) to indicate the end of the program.</p>

Here we find `code` tags without `pre` tags. Of course, each of these `code`
fragments do not require typographical conventions (white-space) to represent
their meaning. So, when the specification indicates that both `pre` and `code`
tags are not required for all code fragments, this is what is being referred to.

> The following example shows how a block of code could be marked up using the
> pre and code elements.
>
>     :::html
>     <pre><code class="language-pascal">var i: Integer;
>     begin
>        i := 1;
>     end.</code></pre>
> 
> A class is used in that example to indicate the language used.

Here we find a code block which contains line breaks and indentation -
"typographical conventions." I think it is safe to assume that both the `pre`
and `code` elements are required in this case. However, as previously mentioned,
after passing the block through a syntax highlighter, the `pre` tag might be
swapped out for a `div`, as the code will now be represented by elements.
Regardless, each individual fragment should be wrapped in a `code` tag as it is
a "string that a computer would recognize."

Finally, did you notice that a class was used in that last example to indicate
the language of the code contained therein? The specification expounds on this
like so:
    
> Although there is no formal way to indicate the language of computer code
> being marked up, authors who wish to mark code elements with the language
> used, e.g. so that syntax highlighting scripts can use the right rules, may do
> so by adding a class prefixed with "language-" to the element.
    
There are a number of interesting things to take away from that one sentence.
First, the explicitly stated use-case for indicating the language would be to
give instructions to syntax highlighting tools. The next logical step would be
that such tools would want to work out-of-the-box with the example markup
provided in the specification. That said, the specification specifically admits
that this is not a formal rule. Therefore, minor deviations can be expected.
Perhaps a specific tool adds additional features like optional line numbering.
As the specification doesn't mention line numbering, that is up to the tool's
implementer to work out. However, in whatever way that it is implemented, it
shouldn't effect any competing tools ability to implement the basic feature of
identifying the language used.

It should also be noted that the specification is careful to point out that the
convention of prefixing "language-" to the class of the element is only a
suggestion (note the expression: "...may do so by..."), albeit a reasonable one.
We wouldn't want to invent some invalid attributes of our own, but we need a way
to identify which class (if there are more than one) specifically identifies the
language of the code. Admittedly, using the prefix "lang-" would be just as
effective. But for consistency's sake, I'd prefer to stick with the suggested
model. Others are free to disagree on this point.

Speaking of disagreements, I've seen arguments on mailing lists about which
element the language identifying class should be set on. Specifically, a class
set on a parent element provides a styling hook for either the parent
(`parent.class`) or the child element (`parent.class child`). However, when the
class is set on the child element, there is no easy way to specify the parent
element from CSS. With libraries that use CSS style selectors (like jQuery),
this same problem can translate to scripts as well. Even though it's not too
hard to obtain the parent of an element in JavaScript, some people have argued
adamantly that the language identifying class should be set on the parent `pre`
tag.

So, why then, does the HTML5 Specification suggest that the class be set on the
child `code` tag? I don't have first-hand knowledge of what influenced the
specification authors, but keep in mind that a language designation is meta-data
specific to "code." A `pre` element can contain any variety of non-code content
(ASCII art, poems, etc.), but a `code` element will always contain code, which
will presumably be identifiable with a specific language. Therefore, setting the
language class on the `code` tag is more semantically correct.

By way of example, how should this snippet[^1] be interpreted?

    :::html
    <pre class="ascii">
    .......... __o
    ............\<,
    .........() / ()
    </pre>

We don't have any "code" so no `code` tag is used. However, some syntax
highlighting tools will try to process the ASCII art simply based on the fact
that a class was set on the `pre` element. Do you see the problem? Without the
`code` element, the script should recognize that this `pre` element does not
contain code. Forcing the class on the `code` element eliminates this
misunderstanding.

Yes, it is evident that the HTML5 Specification authors gave some serious
thought to the semantics of marking up code in an HTML document. Even of you're
not using HTML5, the basic guidelines still apply and should be a baseline for
all syntax highlighting script authors to strive for.

[^1]: That ASCII art was taken from the signature line of David Larson on the
[Framebuilders list](http://groups.google.com/group/framebuilders). I do not
know whether David is the originator of the artwork.

[pre]: http://dev.w3.org/html5/spec/Overview.html#the-pre-element
[code]: http://dev.w3.org/html5/spec/Overview.html#the-code-element
[represents]: http://dev.w3.org/html5/spec/Overview.html#represents
