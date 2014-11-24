title: Reviewing Markdown -- A Response
author: Waylan Limberg
tags: markdown, python
category: Markdown
summary: [Greg Wilson][1] has posted a [code review][2] of [Python-Markdown][3].
    As I'm one of the developers, I read it with interest. This is my response.
    [1]: http://pyre.third-bit.com/
    [2]: http://pyre.third-bit.com/blog/archives/1371.html
    [3]: http://www.freewisdom.org/projects/python-markdown/

[Greg Wilson][1] has posted a [code review][2] of [Python-Markdown][3]. Please [read][] it before continuing. As I'm one of the developers, I read it with interest. This is my response.

[1]: http://pyre.third-bit.com/
[2]: http://pyre.third-bit.com/blog/archives/1371.html
[3]: http://www.freewisdom.org/projects/python-markdown/
[read]: http://www.third-bit.com/pages/reviewing-markdown.html

The purpose of this response it not to criticize Greg. Actually I welcome his criticisms, suggestions and questions. It's always better to have more eyes on a project. That said, a newcomer isn't always aware of the history behind a certain design decision, especially in the context of backward-compatibility. Therefore, my goal is to educate him (and anyone else reading this) on these and answer any questions he asks where I can.

First, I haven't been with the project for all that long, so my knowledge is limited in some areas as well. I've tried to defer to Yuri (the other developer and primary author of most of the code) to answer those questions. However, I have closely followed the Markdown community for some time (including all the various implementations in many languages) and am recently much more involved in Python-Markdown. There are certain things that I have found in the code that would be puzzling to me too, without this background.

Another general observation of mine is that the code is sorely lacking in documentation like comments in some sections, while very well documented in others. I've slowly been working on that, but mostly only with the patches I've applied. In other words, if there are no comments in a section of code, I probably haven't worked with it much. There are exceptions of course. I certainly feel Gregs' pain here, which only increases my appreciation for the time he has put into this.

I've broken the rest of this document up into the same subheadings that Greg used and my responses are organized accordingly.

###Getting Started

Hmm, I suppose we removed the use of `random` and `os` at some point in the past. Guess I'll remove those imports as well. Thanks. Btw, I believe random was used in the past as a replacement for the perl implementation's use of hashes. This has since been replaced with the hard coded (and rather random looking string) in HTML_PLACEHOLDER. As a side note, I believe that markdown.pl's biggest performance hit is its use of hashes and may be why python-markdown1 did not follow suit. It's interesting that python_markdown2 still uses them and outperforms python-markdown1. Perhaps we need to reevaluate.

You ask why we `__import__("optparse")` rather than `import optparse`. I could be wrong (as it was this way before I joined the project), but I believe this is for backward compatibility with python 2.3. Either optparse wasn't part of the python core distribution or was under a different name or something like that. All I can say for sure; there was some weirdness with importing in the past. Yuri could probably provide a better answer here.

Regarding the testing framework: It is in some serious need of upgrading IMO. In fact, some (many?) of the advertised features do not work. Things like hardcoding `/tmp` are just the tip of the iceberg. There has been talk of porting markdown2's testing to markdown1, but no work has been done yet. Once the 1.7 release is finalized (currently at release candidate 1 with a few minor bugs - although Greg has added a few more to the list), I'll be focusing on testing.

###More Landmarks

Regarding safeMode: First, some background. safeMode used to be a boolean equating to `True` or `False` and only did 'replace'. If someone wanted to 'remove', they set HTML_REMOVED_TEXT to an empty string. Recently, we wanted to add support for escaping (which in my view should be the default when safeMode is on). However, we didn't want to break everyones code when they upgraded markdown, so as long as safeMode equates to True (either `True` or any non-empty string) then we assume the old way and 'replace'. The only exceptions are if 'escape' or 'remove' are explicitly set. Had there not been this backward compatibility concern, I would have done things as Greg suggests. I suppose this is were better comments in the code would have helped.

I'll have to defer comments on ENABLE_ATTRIBUTES to Yuri. I've spent very little time inside the dom code. That's his animal.

I'll also defer comments on BIDI and BOM to Yuri. I won't pretend to be an expert on this stuff. Although, I will mention that the code on line 83 was part of a [patch][] submitted by [Malcolm Tredinnick][4]. Malcolm is one smart cookie (he took the lead in converting [Django](http://djangoproject.com) to only use Unicode internally) and so I took his word for it and committed his patch as is. As Greg acknowledges, it works. I never tested whether "Y if X else Z" would do the trick as well. 

[4]: http://www.pointy-stick.com/blog/
[patch]: http://sourceforge.net/tracker/index.php?func=detail&aid=1817528&group_id=153041&atid=790198

###Nanodom

Regarding Greg's comments on BLOCK_LEVEL_ELEMENTS, sets were not available until Python2.4 so that is not an option as we fully support Python2.3. However, Greg is correct; `is_block_level` probably should be renamed to `isBlockLevel` to be consistent. Thanks for the pointer.

Yes, `<:wHR>` on line 448 is a typo. I use vim. `:w` is the command for write/save. Oops. At least it's in a comment.

###Preprocessors

I agree with Greg's comments regarding the way `stash` is assigned to preprocessors. This has been on my todo list for some time. As things work in the current state, its not very high on the list (if its not broke, don't fix it).

Regarding Greg's comments on the `LinePreprocessor`:

* Yes, markdown syntax dictates that all codeblocks must be indented by at least 4 spaces.
* Markdown syntax also dictates that a <hr> must begin with at least 3 dashes.
* I believe the regex for blockquote used here was part of a much later ( and not very well thought out) bug fix.
* Its now obvious that the `LinePreprocessor` could use some refactoring.
 
No doubt, it has become obvious at this point that intimate knowledge of markdown syntax will help in understanding the code. I suspect that Greg was reading the code, in part, to become more familiar with the syntax. I should note that [John Gruber][5]'s syntax has the final say in most instances. Why, even of his own admission, markdown.pl is sometimes wrong and the syntax rules should be followed by authors of other implementations instead. Of course, the exception is when additional syntax has been agreed upon on the markdown list or by precedence set by the first implementation of a feature. In my observation, markdown.pl has always been the slowest to adopt/change, therefore I rarely use it as a reference. The [syntax rules][] however, ... well, memorize them. In my observation, anyone already familiar with markdown coming to a project that claims to use markdown expects it to conform to that specific set of rules in its entirety.

[5]: http://daringfireball.net
[syntax rules]: http://daringfireball.net/projects/markdown/syntax

And now the REFERENCE_PREPROCESSOR.  Any lines of text that begin with 4 or more lines of text are either a codeblock or a nested list item. Therefore, a reference is only a reference if it starts with three or less spaces. Sure, we could require no spaces, but most implementations are not that strict so neither are we. Again, this is an issue of meeting the existing syntax. I'll also note that an understanding of Mr. Gruber's goals and motives when creating the markdown syntax will clear any questions about allowing up to 3 spaces here (the short answer: a few spaces are hard for a human to see so we should allow them).

HtmlBlockPreprocessor: There used to just be preprocessors. They all worked on the same api (they all got split lines -- or was is one string -- I forget) and either split or merged those lines as they needed.  Then, they were broken into preprocessors and textpreprocessors. The api for one takes split lines and the other a single string. Unfortunately, the comments and documentation were never updated to reflect this. It's on my todo list. 

I should also mention that the HtmlBlockPreprocessor code gives me headaches as well. It was there before I came on board and I have generally avoided it with a few minor exceptions. Probably due for a refactor. Thanks for your tips.

###Postprocessors

As with preprocessors, there used to only be one type of postprocessor with a comment saying none existed in core, but that the footnote extension provided an example. Then, some complained that there was no escaping of html blocks (as I discussed above) and no easy way to override the default behavior. At the time, the code in `RawHtmlTextPostprocessor` existed in the `convert` method of the `Markdown` class. I realized this could easily be made a postprocessor to make it easier to override. However, I needed it to work on a single string rather than the dom (there may be other approaches, but this was the approach already taken by the existing code), so I followed the example of the preprocessors. I just documented what I did in the comments. Had the preprocessors been properly documented, I suspect Greg would have pointed to the the Liskov Substitution Principle when discussing them. In any event, this is now on my todo list.

I'm not quite sure why Greg is concerned that there is only one place in the code were escaping takes place. It seems more DRY to me, but maybe I'm missing something.

###InlinePatterns

I appreciate Greg's criticisms of the structure of the `InlinePatterns`. The jumping back and forth has been an annoyance of mine as well. The problem is that the current api is relied upon by extensions and any change to the api would break existing extensions. It's not that we are against a change, but it needs to be done right before it's justified. There's also the issue of nested inline patterns which Greg didn't address here. That needs a better implementation and needs to be considered as well.


###Core Markdown

First of all, despite the comments in the code to the contrary, I think that the core is less ugly than some of the other parts of the code. Of course, I have been working mostly within the core recently and have cleaned some of it up so my opinion may be tainted.

On line 1889, the `convert` method does ` xml = xml.strip()[23:-7] + "\n"` because of the output of the dom. I always thought that was a little strange myself and wondered why the dom's `toxml` method doesn't do that. Yuri?

In `_transform` lines that start with `#` (headers in markdown syntax) are special because they don't get the same treatment as any other block level sections. Namely, they can only be on one line. This is where that is enforced rather than the code that parses headers. Some recent hacking on the headers code was causing me headaches because I forgot about this restriction. This may be something else to refactor. Again, thanks for the pointer.

Someday, if anyone ever finds the time, a thorough read of `_processSection`, would be most welcome. This is probably closest to the top of my list for refactoring. I'd like to see an easy way to add block level sections through an extension mechanism and it's not easy as is. Any and all suggestions are welcome. Of course, if you don't no hard feelings.

That concludes Greg's review of the code. he seemed to skim the rest as he was tired. I'm glad he did. I'm tired as well. But is was fun. Thanks for the pointers Greg. I look forward to seeing Python-Markdown integrated into [DrProject][6].

[6]: http://www.drproject.org/

