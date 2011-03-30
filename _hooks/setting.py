import functools
import markdown
from os import path

Site.CONTEXT.blog = AttrDict(
    url = 'http://achinghead.com/',
    title = 'achinghead.com',
    tag_line = 'about to explode with half-baked ideas',
    author = 'Waylan Limberg',
    mailto = 'waylan@gmail.com',
    )

Site.IGNORE += ('README', 'growl.py')
#Site.DEPLOY_DIR = path.abspath('/home/grebmill/webapps/achinghead/')

Config.transformers['md'] = functools.partial(
                                    markdown.markdown,
                                    extensions = ['extra'])

Config.transformers['markdown'] = Config.transformers['md']
