---
layout: post
title: "Installing multiple versions of Python on Ubuntu from Source"
author: Waylan Limberg
categories: "linux, markdown, python, Ubuntu, VirtualBox"
summary: "Here's how I got Python 2.3, 2.4, 2.5, 2.6 and 3.0 all installed and working on an Ubuntu VirtualBox."
---

In my efforts to fully test [Python-Markdown][], I need to have all versions of [Python][] that are supported by Python-Markdown. This is how I did it -- mostly for my own recollection in the event that I need to do it again. Perhaps others will find it useful as well.

I had previously set up a virtual machine running [Ubuntu Server][] on [VirtualBox][]. By default, I had Python2.5 installed and working fine. Now, I realize that I could have simply done ``apt-get python2.4`` and been done, but I wanted a few more versions. Particularly, Python 2.6 and Python 3.0, which are not yet available through Ubuntu/Debian's standard package manager. There are ways to make it work, but I decided a simple install from source into ``/opt`` was more strait forward. As I understand it, ``/opt`` is where one would install *optional* packages. Additionally, by installing from source with the changed location, each python version would be completely contained within a directory within ``/opt``. If I ever want to remove a version, all I need to do is delete that directory and any associated links.

The first step is to ensure that all dependencies are installed. Run the following once:

    :::bash
    sudo apt-get build-dep python2.5

That will install a bunch of dev packages. Which packages get installed will likely depend of each specific system.

As the remaining commands will need to be repeated for each version of python, I will list them once with X's in place of the version numbers. Be sure to replace the X's with the appropriate version numbers. The various versions and download links can be found on the Python [download][] page.

    :::bash
    wget http://python.org/ftp/python/X.X.X/Python-X.X.X.tgz
    tar xvfz Python-X.X.X.tgz
    cd Python-X.X.X
    ./configure --prefix=/opt/pythonX.X
    make
    sudo make install

In a couple versions I got some warnings after running ``make`` about missing dependencies for things I don't need or use, so I ignored them and everything worked fine. Of course, these need to be on my path to be useful so I created some links:

    :::bash
    sudo ln -s /opt/pythonX.X/bin/pythonX.X /usr/bin/python-X.X

For Python 3.0 I also created a link for ``2to3`` so I could convert code to fit 3.0's changes:

    :::bash
    sudo ln -s /opt/python3.0/bin/2to3 /usr/bin/2to3

The only thing left to do is install some third-party python packages into each. Despite my dislike for some aspects of [SetupTools][], it is an *easy* way to install things quickly, so I installed it on each version. First I downloaded the latest source and unzipped it:

    :::bash
    wget http://pypi.python.org/packages/source/s/setuptools/setuptools-0.X.tar.gz
    tar xvfz setuptools-0X.tar.gz
    cd setuptools-0.X

While I only needed to do the above once, I needed to install it in each version:

    :::bash
    sudo python2.X setup.py install

Note that, (to my knowledge) SetupTools is not yet available for Python 3.0, so I didn't even try. But is worked fine for 2.3, 2.4 and 2.6. Finally, I created links to the various versions of ``easy_install``.

    :::bash
    sudo ln -s /opt/python2.X/bin/easy_install-2.X /usr/bin/easy_install2.X

From now on, it's easy to install a package for any version (except 3.0 which doesn't have any third-party packages to speak of yet) of Python by simply running the appropriate ``easy_install``. For example, the upcoming version 2.0 of Python-Markdown requires [ElementTree][]. While ElementTree is part of the standard library in 2.5 and 2.6, it needs to be installed manually in 2.3 and 2.4. So the following will do the trick:

    :::bash
    sudo easy_install2.4 celementree
    sudo easy_install2.3 celementree

After doing the same for a few other packages (such as [Pygments][] for the [CodeHilite][] extension), I had a everything I needed. And to think it was rather painless.

[Python-Markdown]: http://www.freewisdom.org/projects/python-markdown/
[Python]: http://python.org
[Ubuntu Server]: http://www.ubuntu.com/products/WhatIsUbuntu/serveredition
[VirtualBox]: http://www.virtualbox.org/
[download]: http://python.org/download/
[SetupTools]: http://pypi.python.org/pypi/setuptools/
[ElementTree]: http://pypi.python.org/pypi/cElementTree
[Pygments]: http://pypi.python.org/pypi/Pygments/1.0
[CodeHilite]: http://www.freewisdom.org/projects/python-markdown/CodeHilite


