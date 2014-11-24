title: Git, Interactive Rebase and Ubuntu
category: Linux
tags: git, linux, Ubuntu, VirtualBox
summary: Ubuntu provides an older version of Git that lacks the interactive rebase
    option. Here's how I upgraded and got things working properly for total
    control of of my git repositories.

As mentioned [previously][], I have a Ubuntu VirtualBox VM set up for all my python development. As we use [Git][] for [Python-Markdown][], I installed Git via Ubuntu/Debian's package manager with a simple ``sudo aptitude install git`` -- or so I thought:

    waylan@dev:~$ git
    bash: git: command not found

Oh, right! The [git package][] has nothing to do with Git. I have to use [git-core][]: 

    sudo aptitude install git-core

So, now that I had Git installed, I went on my way, hacking on code and committing each step of the way. Whoops, I just committed an incomplete patch. Oh well, I'll commit the missing pieces separately, and use interactive rebase to squash the two commits. Hmm, what do I put for a commit message? Oh, who cares, it's a throw-away message anyway... And then I am horrified to discover that the version of Git I have is as 1.5.2.5 but interactive rebase wasn't added until 1.5.3. Therefore, Python-Markdown has commits like [this][foo] and [this][revert foo]. Grrr.

Curiously, my primary machine has a new version of Git installed. Oh, right. Apt is broken on that machine (I haven't bothered to debug it yet) and I had to manually download and install Git there. I might as well do the same on my dev VM. So, I go to the Git site, and to my delight, they host [deb files][] of the most recent builds of Git.

    wget http://www.backports.org/debian/pool/main/g/git-core/git-core_1.5.6.5-1~bpo40+1_i386.deb
    sudo dpkg --install git-core_1.5.6.5-1~bpo40+1_i386.deb

That's better. I type ``git rebase -i HEAD~5`` and my editor opens with the last five commits (``HEAD~5``) listed along with some helpful instructions:


    pick 358decd A few more tweaks to extension loading. We don't test trying to load non-existant or broken extensions often enough. This should handle things better.
    pick b443efa foo
    pick 971d605 Revert "foo"
    pick c669bf0 One more tweak to extension loading.
    pick d6711cf Normalized stripTopLevelTags to be consistant regardless of any whitespace. For example, this would allow an extension to remove/replace 'Prettify' treeprocessor with something that added more or less whitespace without adverse effects.

    # Rebase c1f4bc1..d6711cf onto c1f4bc1
    #
    # Commands:
    #  pick = use commit
    #  edit = use commit, but stop for amending
    #  squash = use commit, but meld into previous commit
    #
    # If you remove a line here THAT COMMIT WILL BE LOST.
    # However, if you remove everything, the rebase will be aborted.
    #

The instructions are pretty self explainitory. So I edit the file like so and save it:

    pick 358decd A few more tweaks to extension loading. We don't test trying to load non-existant or broken extensions often enough. This should handle things better.
    squash c669bf0 One more tweak to extension loading.
    pick d6711cf Normalized stripTopLevelTags to be consistant regardless of any whitespace. For example, this would allow an extension to remove/replace 'Prettify' treeprocessor with something that added more or less whitespace without adverse effects.

The rebase runs with one more stop in the editor for me to edit the commit message. After saving that, the logs are now fixed up all nice and pretty. To bad I had pushed those changes public before the rebase. Now that others have cloned the bad commits, their clones will never merge properly with the fixed one. Oh well, at least I have the tools in place to avoid doing that again.

One other cool (undocumented) feature of interactive rebase is that if you reorder the commits, they will be reordered in the log as well. In the event that the rebase runs into a conflict (which could easily happen when reordering) it will pause, allow you to fix the conflict and continue with the command:

    git rebase --continue

This is one of the reasons I really like Git. As a distributed system, I can commit locally, edit/reorder/remove/combine those commits however I like and only when I am happy with everything, push those commits to a public repo for the world to see. Yes, that means I don't push after each commit -- only after a feature is complete.

[previously]: http://achinghead.com/archive/83/installing-multiple-versions-python/
[Git]: http://git.or.cz/
[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/
[foo]: http://gitorious.org/projects/python-markdown/repos/mainline/commits/b443efad9ae25f8f8ab421907d71c2b87e3b095a
[revert foo]: http://gitorious.org/projects/python-markdown/repos/mainline/commits/971d605e2e1d0652b5ea161fe0c35a40d9685e5c
[git package]: http://packages.ubuntu.com/gutsy/git
[git-core]: http://packages.ubuntu.com/gutsy/git-core
[deb files]: http://www.backports.org/debian/pool/main/g/git-core
