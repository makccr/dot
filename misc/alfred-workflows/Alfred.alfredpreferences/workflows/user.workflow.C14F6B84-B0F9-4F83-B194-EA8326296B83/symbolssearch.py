from __future__ import unicode_literals
import sys
from cgi import escape


class AlfredItemsList(object):
    def __init__(self, items=None):
        self.items = items or []
        self.pattern = \
            '<item arg="{arg}" uid="{uid}">' + \
            '<title>{title}</title>' + \
            '<subtitle>{subtitle}</subtitle>' + \
            '<icon>{icon}</icon></item>'

    def append(
            self,
            arg,
            title,
            subtitle,
            uid=None,
            icon='icon.png',
    ):
        self.items.append(
            (arg, escape(title), escape(subtitle), icon, uid)
        )

    def __str__(self):
        items = "".join([
            self.pattern.format(
                arg=escape(arg),
                title=escape(title),
                subtitle=escape(subtitle),
                icon=icon,
                uid=uid
                ) for arg, title, subtitle, icon, uid in self.items
            ]
        )
        return ('<items>' + items + '</items>').encode('utf-8')

    def __add__(self, other):
        return AlfredItemsList(self.items + other.items)


def split_symbol(raw_symbol):
    code, symbol, description = raw_symbol.split('\t')[:3]
    return {
        'arg': symbol,
        'title': symbol,
        'subtitle': description,
        'uid': code,
        'icon': 'noicon.png'
    }


r = AlfredItemsList()

query = ' '.join((s.decode('utf-8') for s in sys.argv[1:]))
query_words = query.split(' ')

with open('symbols.txt') as f:
    symbols = f.read().decode('utf-8').splitlines()

is_first = True
for raw_symbol in symbols:
    if all((q in raw_symbol for q in query_words)):
        kwargs = split_symbol(raw_symbol)
        if is_first:
            kwargs['icon'] = 'icon.png'
            is_first = False
        r.append(**kwargs)
print r
