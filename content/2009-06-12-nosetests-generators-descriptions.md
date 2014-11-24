title: Nosetests, Generators and Descriptions
tags: python, Python Nose, testing
category: Python
summary: I've recently been playing around with the nose testing framework for
    Python. It's pretty slick! With the various hooks for plugins, one can make it
    work pretty much however one wants. And what I especially like is support for
    generators. However, even with all this power, giving a meaningful name to each
    generated test is less than straightforward. Here are a few approaches that
    work.

I've recently been playing around with the [nose][] testing framework for Python. It's pretty slick! With the various hooks for plugins, one can make it work pretty much however one wants. And what I especially like is support for generators.
    
That is, given a iterable of some kind, a test function can yield a series of tests. In my case, I actually am walking a directory structure and returning a separate test for each data file. Via a plugin, I'm even able to customize the output of these specific tests to alter the failure reports by removing unhelpful information and/or otherwise making them more useful. However, even with all this power, giving a meaningful name to each generated test is less than straightforward. There's even a [bug report][] regarding the issue.

To illustrate, let's look at a simple nose test function:

    def test_foo():
        """ Test Foo """
        assert False, 'Foo failed'

Run that test and you'll get:

    F
    ======================================================================
    FAIL: Test Foo
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/usr/lib/python2.5/site-packages/nose-0.11.0-py2.5.egg/nose/case.py", line 183, in runTest
        self.test(*self.arg)
      File "/home/waylan/tmp/nose/test_foo.py", line 3, in test_foo
        assert False, "Foo failed"
    AssertionError: Foo failed
    
    ----------------------------------------------------------------------
    Ran 1 test in 0.014s
    
    FAILED (failures=1)

In this case, as with Unittest, the description was pulled from the doc string. Alternatively, we could set a description attribute on the test:
    
    test_foo.description = 'Test Foo'

So far so good. But now let's move on to generators. A basic generator would look something like this:

    def run_bar(n):
        assert False, 'Test %d failed' % n
    
    def test_bar():
        for n in range(2):
            yield run_bar, n

The output from running this test:
    
    FF
    ======================================================================
    FAIL: test_foo.test_bar(0,)
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/usr/lib/python2.5/site-packages/nose-0.11.0-py2.5.egg/nose/case.py", line 183, in runTest
        self.test(*self.arg)
      File "/home/waylan/tmp/nose/test_foo.py", line 8, in run_bar
        assert False, 'Test %d failed' % n
    AssertionError: Test 0 failed

    ======================================================================
    FAIL: test_foo.test_bar(1,)
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/usr/lib/python2.5/site-packages/nose-0.11.0-py2.5.egg/nose/case.py", line 183, in runTest
        self.test(*self.arg)
      File "/home/waylan/tmp/nose/test_foo.py", line 8, in run_bar
        assert False, 'Test %d failed' % n
    AssertionError: Test 1 failed

    ----------------------------------------------------------------------
    Ran 2 tests in 0.014s

    FAILED (failures=2)

Now, in this simple case, test names like `test_foo.test_bar(1,)` are not that bad. But start passing more complex arguments to your tests and things get ugly real fast. In my case, I'm passing a long string containing a file's absolute path as well as a ConfigParser instance. Ugh. 

Oh, and if your wondering why I didn't just use doc strings; that would simply give every test the same description, which isn't very helpful. The first (and seemingly obvious solution) would be to use the description attribute. Something like:
    
    def test_bar():
        for n in range(2):
            run_bar.description = 'Test bar with %d' % n
            yield run_bar, n

But, alas, every test now takes on the name of the very last test run! What!?! With some thought, I realized that every test was using the same instance of the test function. Therefore, by the time the report was generated, all the tests had already run, and the description attribute was always going to be for the last run test.

Ah, but, if each test uses a different instance of the test, then perhaps the description of each test could be unique. So, I made the test function a callable class and set the description on each instance:
    
    class RunBaz:
        def __init__(self, n):
            self.description = 'Test baz with %d' % n
        def __call__(self, n):
            assert False, '%d failed' % n

    def test_baz():
        for n in range(2):
            yield RunBaz(n), n

Sure enough, it works!:

    FF
    ======================================================================
    FAIL: Test baz with 0
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/usr/lib/python2.5/site-packages/nose-0.11.0-py2.5.egg/nose/case.py", line 183, in runTest
        self.test(*self.arg)
      File "/home/waylan/tmp/nose/test_foo.py", line 18, in __call__
        assert False, '%d failed' % n
    AssertionError: 0 failed

    ======================================================================
    FAIL: Test baz with 1
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/usr/lib/python2.5/site-packages/nose-0.11.0-py2.5.egg/nose/case.py", line 183, in runTest
        self.test(*self.arg)
      File "/home/waylan/tmp/nose/test_foo.py", line 18, in __call__
        assert False, '%d failed' % n
    AssertionError: 1 failed

    ----------------------------------------------------------------------
    Ran 2 tests in 0.018s

    FAILED (failures=2)

Of course, the need to pass the arguments into the test twice (`yield RunBaz(n), n`) is not very DRY. This would certainly work if the description needs to be built with more than just the arguments passed in for running the test. However, if we only need to use the arguments, we can make it a little simpler:

    class RunBaz:
        def __call__(self, n):
            self.description = 'Test baz with %d' % n
            assert False, '%d failed' % n

    def test_baz():
        for n in range(2):
            yield RunBaz(), n

Just set `self.description` right in the `__call__` method. <del>The output is exactly the same as before</del> <ins>Upon further testing, it appears that this method does not work. Every test gets the name of the last test run for the same reason explained earlier</ins>.
        
But, now I see someone has recently described a [workaround][] in the bug report that uses functools' [partial][] method, which essentially does the same thing. 

Sigh. 

However, it appears that functools was only added to the standard library in Python 2.5. As I need to support earlier versions of Python, I guess my work was not all in vain. The important thing here is that generated tests in nose can have unique descriptions using a variety of methods. Pick whichever method meets your needs.

Now go write some generated tests with helpful descriptions.

[nose]: http://somethingaboutorange.com/mrl/projects/nose/
[bug report]: http://code.google.com/p/python-nose/issues/detail?id=244
[workaround]: http://code.google.com/p/python-nose/issues/detail?id=244#c1
[partial]: http://docs.python.org/library/functools.html#functools.partial
