---
layout: post
title: "Enhancing Django Wikiproject Part 1 - Adding Authentication"
author: Waylan Limberg
categories: "markdown, python"
summary: "Adding some simple authentication using Django's built in system to Paul Bisex's simple wikiproject."
---

<p>In playing with, and trying to learn <a href="http://www.djangoproject.com/" title="Ubber Cool Python Web-Framework">Django</a>, I've been tampering with <a href="http://e-scribe.com/news/">Paul Bisex</a>'s <a href="http://e-scribe.com/news/171">wikiproject</a>. While he stated that he doubt's anyone would actually want to use his simple creation, I saw potential. There were a few minor improvments that I imedietly saw, but I'll get to those later.
</p>
<p>The first thing I want to dicuss is what I see as a nessecary step in any content that can potentially be edited by anyone with internet access. Your just asking to be spammed without any safeguards in place. The easiest is a simple authentication system. This is even easier with Django's built in <a href="http://www.djangoproject.com/documentation/authentication/" title="User authentication in Django">user authentication system</a>. While we could set up groups and set permission levels, a super simple wiki only needs one permission - edit. That being the case, we only need to allow editing if a user is logged in, regardless of permissions. According to the <a href="http://www.djangoproject.com/documentation/authentication/#the-raw-way" title="The raw way">docs</a>:
</p>
<blockquote><p>The simple, raw way to limit access to pages is to check <code>request.user.is_anonymous()</code> and ... display an error message.
</p>
</blockquote><p>So, if a user is logged in, everything should work as normal. However, if a request is made for a non-existant page by an anonymous (not logged in) user, then they should not be given the opportunity to edit the page. While some choose to redirect to a login page here, I prefer the 404 Not Found HTTP Response Header. That allows no room for confusion<sup id="fnr1-548444471"><a href="#fn1-548444471">1</a></sup> among users or search engines. This is easy enough with the <a href="http://www.djangoproject.com/documentation/request_response/#httpresponse-subclasses" title="HttpResponse subclasses">HttpResponse subclass</a> <code>HttpResponseNotFound</code>.
</p>
<p>First we need to import <code>HttpResponseNotFound</code> so let's add it to the first line of views.py:
</p>
<pre><code>from django.utils.httpwrappers import HttpResponse, HttpResponseRedirect, HttpResponseNotFound
</code></pre><p>Then, alter the <code>page</code> view as follows:
</p>
<pre><code>def page(request, title):
    &quot;Display page, 404 Not Found error, or create page if logged in&quot;
    try:
        page = wikipages.get_object(title__exact=title)
        return render_to_response('page', locals())
    except wikipages.WikipageDoesNotExist:
        if request.user.is_anonymous():
            # send 404 Not Found
            return HttpResponseNotFound()
        else:
            # create a dummy page object
            page = wikipages.Wikipage()
            page.title = title
            return render_to_response('edit', locals())
</code></pre><p>At first I was going to do the same thing for the <code>edit</code> view, but return a 403 Forbidden HTTP Response Header. However, it occured to me that when an edit is expressly requested, redirecting to a login page would be more intuitive. This, as usual, is super easy with Django. As the <a href="http://www.djangoproject.com/documentation/authentication/#the-login-required-decorator" title="The login_required decorator">docs</a> point out:
</p>
<blockquote><p>As a shortcut, you can use the convenient <code>login_required</code> decorator.
</p>
</blockquote><p>Its that easy. The trick is that the syntax is different for Python versions 2.3 and 2.4 but either way, its only one line of code outside the <code>edit</code> view. First, we need to import it:
</p>
<pre><code>from django.views.decorators.auth import login_required
</code></pre><p>Python 2.3:
</p>
<pre><code>def edit(request, title):
    # ...
edit = login_required(edit)
</code></pre><p>Python 2.4:
</p>
<pre><code>@login_required
def edit(request, title):
    # ...
</code></pre><p>Which brings us to the next step; a login page. As <code>login_required</code> automaticly redirects to <code>/accounts/login/</code>, we will need to create a login page accordingly. First, we need to tell Django what to do with that url, so open <code>url.py</code> and add the following as the first listing:
</p>
<pre><code>(r'^accounts/login/', 'django.views.auth.login.login'),
</code></pre><p>Yes, we are actually using the view code built right into Django, which means less work for us - generally a good thing. That view code calls a template <code>registration/login.html</code>. Of course, that does not exist, but we can use the Admin app default as a base. You should find these at <code>...django_src/django/contrib/admin/templates/</code>. I choose to copy that <code>templates/</code> directory in its entirety to my <code>wikiproject/</code> directory. You may want to browse around and see what you may find useful in there and delete what you won't need.<sup id="fnr2-548444471"><a href="#fn2-548444471">2</a></sup> Before deleting the <code>admin/</code> directory, make sure to copy login.html from there to <code>registration/</code>, which, of course we do NOT want to delete as it contains the templates we need.
</p>
<p>Now we need to tell Django were to find these templates. Open the settings.py file and add the following to <code>TEMPLATE_DIRS</code> 
</p>
<pre><code>'templates/',
</code></pre><p>These templates extend the Admin base template and if you have the admin app enabled they will work now with the Admin styling. Go ahead and give them a test.<sup id="fnr3-548444471"><a href="#fn3-548444471">3</a></sup> Type the url to edit a page directly into the browser's address bar, and you should be redirected to the login page. Assuming you have created a user<sup id="fnr4-548444471"><a href="#fn4-548444471">4</a></sup>, enter that username and password and submit. You should be redirected to the edit form for your page.
</p>
<p>Of course, who wants the admin style only for a login page used by non-admins?<sup id="fnr5-548444471"><a href="#fn5-548444471">5</a></sup> Open <code>registration/login.html</code> and alter the first line to extend our wiki's base:
</p>
<pre><code>{% raw %}{% extends &quot;base&quot; %}{% endraw %}
</code></pre><p>As we don't have any need for the breadcrumb stuff, we can remove that line:
</p>
<pre><code>{% raw %}{% block breadcrumbs %}{% endblock %}{% endraw %}
</code></pre><p>While your at it, you may want to make a few other adjustments to the markup to fit in with your preferred style.<sup id="fnr6-548444471"><a href="#fn6-548444471">6</a></sup> 
</p>
<p>Users can now log in, but they need to be able to log out. We just need to do the same thing as we did for logging in. In urls.py add the following:
</p>
<pre><code>(r'^accounts/logout/', 'django.views.auth.login.logout'),
</code></pre><p>Then, make the same changes to <code>registration/logged_out.html</code> as you did to <code>registration/login.html</code>. While you're at it, you may want to adjust the url to 'log back in' so it points to <code>/accounts/login/</code>.
</p>
<p>The only thing left is to add a login/out link to our templates, add edit links to the index page (which only display for logged in users) and we have a much more useful wiki. It's even starting to look like something I would use for my own personal site. Especially if I used <a href="http://www.freewisdom.org/projects/python-markdown/" title="Markdown in Python">Markdown</a> instead of Paul's WikiLinks. As I've noted previously, I could even <a href="http://achinghead.com/archives/67/adding-wikilinks-to-markdown-in-python/" title="Adding WikiLinks to Markdown in Python">combine the two</a>.
</p>

<p>Feel free to use the code I have provided here. As with Paul's, consider it licenced under the MIT Licence. And look for Part 2 were I go over a number of little things that really clean it up and make it easy to use.
</p>

<div class="footnote"><hr /><ol>
 <li id="fn1-548444471">
     One could always include a link to a login page in their custom error page. You do have custom error pages don't you? Whether such is left to the http server, of handled by Django shouldn't matter. With a few modifications to your server settings (perhaps in Apache's .htaccess file) or to my code this should be easy enough, but is left as an exersize for the reader. Perhaps I'll include that in part 2. <a href="#fnr1-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
 </li>

 <li id="fn2-548444471">
     My understanding is that if one desires to customize or alter the Admin templates for use with the Admin app, the same practice would be followed and all edits would take place on this copy. As an aside, you may also note that 404 and 405 error templates are available here and can be easily adapted to work with the previous footnote. <a href="#fnr2-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
 </li>

 <li id="fn3-548444471">
     I should mention that I have been testing this all along by using the admin app to log in and out from another browser tab. As both tabs use the same session data, it works fine, but is not really an ideal situation. Besides, you may not want to give page editors access to the admin interface, which you use to add and delete users. This way, they can still log in without ever seeing the admin interface. Just make sure they have no admin privliges when you create their account. Remember, our little wiki app only checks if they are logged in, but never checks what permissions they have, so you could give them no permisions but they can still edit wikipages as long as they can log in. <a href="#fnr3-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
 </li>

 <li id="fn4-548444471">
     If you havn't done so already, create a superuser from the command line by doing:
<pre><code>python manage.py createsuperuser
</code></pre>
<p>You will then be prompted for a username, email address and password. <a href="#fnr4-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
</p>
 </li>

 <li id="fn5-548444471">
     You may actually want to leave the admin styling in tact, as the admin interface will use these altered templates over the defaults we copied them from. If you follow the last few steps here, the login and logout pages for the admin will match the styling of the wiki no matter what app in the project you may be using the admin interface for. I'm not aware of, not did I look for an easy workaround. Consider yourself warned. <a href="#fnr5-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
 </li>

 <li id="fn6-548444471">
     For example, I edited all the templates to use a title block so that the page title and/or the action (edit, login) was displayed at the top of the browser window/tab. <a href="#fnr6-548444471" class="footnoteBackLink" title="Jump back to footnote 1 in the text">&#8617;</a>
 </li>
</ol>
</div>
