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

""" --- Set up Markdown --- """

from markdown.extensions.codehilite import CodeHilite

class JSliter(markdown.treeprocessors.Treeprocessor):
    """ Prepare code blocks for a JS code highlighter. """

    def run(self, root):
        """ Find code blocks, id language and set as class. """
        blocks = root.getiterator('pre')
        for block in blocks:
            children = block.getchildren()
            if len(children) == 1 and children[0].tag == 'code':
                code = children[0]
                ch = CodeHilite(code.text)
                ch._getLang()
                if ch.lang:
                    if ch.lang == 'no-highlight':
                        code.set('class', ch.lang)
                    else:
                        code.set('class', 'language-%s' % ch.lang)
                    code.text = '%s\n' % ch._escape(ch.src)


class JSliterExt(markdown.Extension):
    """ Add JSliter to Markdown instance. """

    def extendMarkdown(self, md, md_globals):
        liter = JSliter(md)
        md.treeprocessors.add('hilite', liter, '_begin')



Config.transformers['md'] = functools.partial(
                                    markdown.markdown,
                                    extensions = ['extra', JSliterExt()])

Config.transformers['markdown'] = Config.transformers['md']
