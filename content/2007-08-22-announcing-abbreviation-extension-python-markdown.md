title: Announcing the Abbreviation Extension for Python-Markdown 
category: Markdown
tags: markdown, python
summary: I've just released my first try at an [Abbreviation Extension][abbr] for
    [Python-Markdown][python]. Here's how it came about.
    [abbr]: http://achinghead.com/markdown/abbr/
    [python]: http://www.freewisdom.org/projects/python-markdown/

I'm proud to announce the [Abbreviation Extension][abbr] for [Python-Markdown][python].

[abbr]: http://achinghead.com/markdown/abbr/
[python]: http://www.freewisdom.org/projects/python-markdown/

Some time ago, [Seemant Kulleen][1] sent me an email asking for help. Apparently he was trying to adapt the code in my [wikilink][2] extension to write an abbreviation/acronym extension for [Python-Markdown][3]. At the time I was way to busy and didn't even read over his code. Although, I believe I did send a short reply. I'm not that rude.

After some time had passed, I noticed Seemant had [posted][4] his non-working code to his blog and expressed his frustrations. As I noted in my comment to that post, I  was able to get his code working with only a few minor adjustments. After some private emailing back and forth, Seemant indicated that  the code was mine to do with as I pleased. It looked something like [this][5]. 

But, before I released it, I checked the syntax to see if Seemant had followed the previously established syntax in [PHP Markdown Extra][6]. He hadn't. We'll give him the benefit of the doubt and assume he wasn't aware a syntax had already been established. Regardless, I set the code aside and forgot about it.

Then, the other week I was going through some of my working files and deleting old dead stuff, or at least archiving it out of the way, and stumbled on that code. It occurred to me that I could use the `Pattern` class we already have and pass it a different pattern for each abbreviation defined by reference. True, this would add another instance of the class for each abbreviation, but, given the fact that the extension hasn't existed for some time, it can be assumed that most documents would contain very few abbreviation definitions. So, why not? After fighting with the preprocessor bit, I have [working code][7]. Perhaps it's not the best approach, but it works.

My future plans for the extension include the ability to define a default set of abbreviations which will automatically be applied to any markdown text, even if they are not defined within the document itself. Of course, this should be turned off by default, but a simple switch is much quicker and easier that copying the same abbreviations from document to document. I anticipate offering the ability to define them in code (perhaps as a python dict) or as a file (default location being the same as the source file). I suspect my approach to the code will need to change for this to work effectively. I have a few ideas, but any suggestions in this regard are welcome.

[1]: http://www.kulleen.org/blog/
[2]: http://achinghead.com/markdown/wikilink/
[3]: http://www.freewisdom.org/projects/python-markdown/
[4]: http://www.kulleen.org/seemant/blog/2007/jun/05/building-my-django-weblog-part-65/
[5]: https://code.achinghead.com/browser/mdx/abbr/trunk/mdx_acronyms.py?rev=47
[6]: http://www.michelf.com/projects/php-markdown/extra/#abbr
[7]: https://code.achinghead.com/browser/mdx/abbr/trunk/mdx_abbr.py