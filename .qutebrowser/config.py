config.load_autoconfig()
c.auto_save.session = False
c.content.geolocation = 'ask'
c.content.javascript.can_close_tabs = False
c.content.javascript.can_open_tabs_automatically = False
c.content.javascript.enabled = True
c.content.media_capture = 'ask'
c.content.notifications = 'ask'
c.downloads.location.remember = True
c.downloads.position = 'bottom'
c.hints.auto_follow_timeout = 2000
c.scrolling.bar = 'when-searching'
c.scrolling.smooth = True
c.statusbar.hide = False
c.statusbar.padding = {'top': 2, 'bottom': 2, 'left': 0, 'right': 0}
c.statusbar.position = 'top'

##   - url: Current page URL.
##   - scroll: Percentage of the current page position like `10%`.
##   - scroll_raw: Raw percentage of the current page position like `10`.
##   - history: Display an arrow when possible to go back/forward in history.
##   - tabs: Current active tab, e.g. `2`.
##   - keypress: Display pressed keys when composing a vi command.
##   - progress: Progress bar for the current page loading.
c.statusbar.widgets = ['keypress', 'url', 'history', 'tabs', 'progress']
c.tabs.background = False
c.tabs.close_mouse_button = 'right'
c.tabs.close_mouse_button_on_bar = 'new-tab'
c.tabs.last_close = 'startpage'
c.tabs.show = 'multiple'
c.tabs.title.alignment = 'center'
c.url.default_page = 'https://makccr.github.io/'
c.url.start_pages = ['https://makccr.github.io']
c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}'}
c.window.hide_decoration = True
c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']

# ||\\ //|| 
# || \// || Mackenzie Criswell
# || //\ || https://makc.co
# ||   \\|| https://github.com/makccr
