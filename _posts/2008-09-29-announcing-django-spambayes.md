---
layout: post
title: "Announcing Django-SpamBayes"
author: Waylan Limberg
categories: "anti-spam, django, python"
summary: " I've just released [Django-SpamBayes][] v0.1 which includes a few utility apps for [Django][] that offer an easy to use interface to the [SpamBayes][] statistical anti-spam filter allowing filtering and moderation (with training) of comments, contact forms and other publicly submitted data.  Currently, two applications are available: [DjangoBayes][], which wraps the Django model and provides the SpamBayes API; and [CommentBayes][], which is an add-on to Django's [contrib.comments][] application and provides filtering and moderation of comments through signals.  [Django-SpamBayes]: http://code.google.com/p/django-spambayes/ [Django]: http://djangoproject.com/ [SpamBayes]: http://spambayes.sourceforge.net/ [DjangoBayes]: http://code.google.com/p/django-spambayes/source/browse/trunk/docs/djangobayes.txt [CommentBayes]: http://code.google.com/p/django-spambayes/source/browse/trunk/docs/commentbayes.txt [contrib.comments]: http://docs.djangoproject.com/en/dev/ref/contrib/comments/"
---

As many of you may know, there are various methods out there for blocking spam in comments, wiki pages, contact forms and other such publicly submitted data. One of the more popular is [Akismet][]. Another is the ["honey-pot"][] method. They both certainly have their place, but they both have their shortcomings as well. 

For example. While the "honey-pot" seems to do it's job of blocking dumb spam-bots, what about spam from real live humans? The same applies to CAPTCHAs. Besides, it's only a matter of time before someone writes a bot that works around a widely distributed honey-pot, like the one found in Django's new [contrib.comments][] app.

And then there's Akismet's problems. As [Alberto G.][] [points out][]:

> I don't like Akismet because it's too simple. It only tells you if they think the comment is spam, so the best you can do is skip writing comments to the database. It would be nice if it returned a probability, so you could act accordingly.

I couldn't agree more. Interestingly, that's exactly what an [e-mail statistical anti-spam filter][better] does. It just so happens that the *best* statistical anti-spam filter (IMO) happens to be written in pure Python. Meet [SpamBayes][]. There shouldn't be any reason why I can't tap into that from within my [Django][] projects. It turns out I was right.

Now, I realize many people think of SpamBayes as an Outlook plugin. While there is such a thing, it's core is the Python ``spambayes`` package which is available as opensource Python code under a MIT license. Cool! Additionally, the core devs have contemplated that the filter could be used in any number of setups and have made it easy to add your own backends and/or wrap SpamBayes within your own APIs. Unfortunately, there's little documentation in this regard, but the source code is well commented and easy to follow.

With little effort, I was able to create a storage backend for SpamBayes that wrapped a Django model. Once I had that, I could access the SpamBayes API from within any Django App. Thus, [Django-SpamBayes][] was born. Django-SpamBayes is a collection of utility applications for Django that utilize SpamBayes for spam filtering. Currently, two applications are available: [DjangoBayes][], which wraps the Django model and provides the SpamBayes API; and [CommentBayes][], which is an add-on to Django's [contrib.comments][] application and provides filtering and moderation of comments through signals.

Unfortunately, the moderation features of contrib.comments is undocumented, but it you point your browser at ``http://yourdomain.com/comments/moderate/`` you'll get a nice admin-looking moderation interface. Perhaps in the future I'll get it integrated into the admin itself.

Until then, check out the [project page][] or get it from [PyPI][].

**Note:** This blog is running on a *very old* version of Django and for that reason, is not yet using Django-Spambayes for comment moderation. Hopefully someday... At least there's a simple [demo app][] in the Subversion repo.

[Akismet]: http://akismet.com/
["honey-pot"]: http://www.davidcramer.net/code/293/dealing-with-automated-form-submission-spam.html
[Alberto G.]: http://bynotes.com/fiam/
[points out]: http://fi.am/entry/preventing-spam/
[contrib.comments]: http://docs.djangoproject.com/en/dev/ref/contrib/comments/
[better]: http://www.paulgraham.com/better.html
[SpamBayes]: http://spambayes.sourceforge.net/
[Django]: http://djangoproject.com/
[Django-SpamBayes]: http://code.google.com/p/django-spambayes/
[DjangoBayes]: http://code.google.com/p/django-spambayes/source/browse/trunk/docs/djangobayes.txt
[CommentBayes]: http://code.google.com/p/django-spambayes/source/browse/trunk/docs/commentbayes.txt
[project page]:  http://code.google.com/p/django-spambayes/
[PyPI]: http://pypi.python.org/pypi/django-spambayes/
[demo app]: http://code.google.com/p/django-spambayes/source/browse/#svn/trunk/sb_demo