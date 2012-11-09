# Deploy GH_Pages
#
# Based on code from:
# https://github.com/xfire/growl/blob/master/_hooks/deploy_rsync.py

import subprocess

BRANCH = 'gh-pages'

@wrap(Site.setupOptions)
def setupOptions(forig, self, parser):
    forig(self, parser)
    parser.set_defaults(deploy = False)
    parser.add_option('--deploy',
                      action = 'store_true', dest = 'deploy',
                      help = 'deploy site to %s branch' % BRANCH)

@wrap(Site.run)
def run_subtree(forig, self):
    # first run 'default' actions and maybe other run hooks
    #forig(self)

    if self.options.deploy:
        cmd = 'git subtree split --branch %s --prefix %s' % (BRANCH, self.DEPLOY_DIR)
        sys.stderr.write('deploy to >>> %s\n' % BRANCH)
        ret = subprocess.call(cmd, shell=True)
        if ret == 0:
            sys.stderr.write('<<< finished\n')
        else:
            sys.stderr.write('<<< failed! (return code: %d)/n' % ret)
