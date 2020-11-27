#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    file:      include the content of an XML file        {file => "/path/to/file.xml"},
    raw:       any XML data supported by Openbox          {raw => q(xml data)},
    begin_cat: beginning of a category              {begin_cat => ["name", "icon"]},
    end_cat:   end of a category                      {end_cat => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [
	{sep => "ArcoLinux"},
    #          COMMAND                 LABEL                ICON
    {item => ['exo-open --launch TerminalEmulator',                                 'Terminal',          'terminal']},
    {item => ['exo-open --launch FileManager',                                      'File Manager',      'file-manager']},
    {item => ['exo-open --launch WebBrowser ',                                      'Web Browser',       'webbrowser-app']},
    {item => ['geany',                                                              'Text Editor',       'geany']},
    {sep => undef},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Other',       'applications-other']},
    {cat => ['settings',    'Settings',    'gnome-settings']},
    {cat => ['system',      'System',      'applications-system']},

    #{cat => ['qt',          'QT Applications',    'qt4logo']},
    #{cat => ['gtk',         'GTK Applications',   'gnome-applications']},
    #{cat => ['x_xfce',      'XFCE Applications',  'applications-other']},
    #{cat => ['gnome',       'GNOME Applications', 'gnome-applications']},
    #{cat => ['consoleonly', 'CLI Applications',   'applications-utilities']},

    {sep => undef},
    {pipe => ['am-places-pipemenu',         'Places',       'folder']},
    {pipe => ['am-recent-files-pipemenu',   'Recent Files', 'folder-recent']},

    ## Custom advanced settings
    #{sep => "Settings"},
    {sep => undef},

    {pipe => ['am-conky-pipemenu',  'Conky',        'conky']},

    {begin_cat => ['Preferences', 'theme']},

        {item => ['nitrogen',                               'Nitrogen',         'nitrogen']},
        {item => ['gksudo lightdm-gtk-greeter-settings',    'LightDM Appearance',       'theme']},
        {item => ['lxappearance',                           'Lxappearance',             'theme']},
        {item => ['geany ~/.config/termite/config',         'Termite Appearance',       'theme']},
        {item => ['xfce4-appearance-settings',              'Xfce4 Appearance',         'preferences-desktop-theme']},
        {sep => undef},
        {item => ["gksudo geany /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm.conf",  'Login Settings','login']},
        {item => ['exo-preferred-applications',             'Preferred Applications',   'preferred-applications']},
        {item => ['system-config-printer',                  'Printing',                 'printer']},
        {item => ['pavucontrol',                            'Sound Preferences',        'multimedia-volume-control']},
        {item => ['xfce4-settings-manager',                 'Xfce4 Settings Manager',   'preferences-desktop']},
        {sep => undef},

        {pipe => ['am-compositor',      'Compositor',      'compton']},
        {begin_cat => ['Openbox', 'openbox']},
            {item => ["$editor ~/.config/openbox/menu.xml",     'Edit menu.xml',                 'text-xml']},
            {item => ["$editor ~/.config/openbox/rc.xml",       'Edit rc.xml',                   'text-xml']},
            {item => ["$editor ~/.config/openbox/autostart",    'Edit autostart',                'text-xml']},
            {sep => undef},
            {item => ['obmenu3',                                'GUI Menu Editor',               'theme']},
            {item => ['obconf',                                 'GUI Config Tool',               'theme']},
            {item => ['obkey',                                  'GUI Keybinds',                  'theme']},

            {sep => undef},
            {item => ['openbox --restart',                      'Restart Openbox',               'openbox']},
            {item => ['openbox --reconfigure',                  'Reconfigure Openbox',           'openbox']},
        {end_cat => undef},
        {pipe => ['am-tint2-pipemenu',  'Tint2',        'tint2']},
        {item => ['tint2conf',          'Tint2 GUI',    'tint2conf']},
    {end_cat => undef},

     # Preferences
    {begin_cat => ['System Settings', 'settings']},
        {item => ['pamac-manager',  'Pamac Updater and Package Manager',    'pamac']},
        {sep => undef},
        {item => ["gksudo thunar",  'File Manager As Root',     'thunar']},
        {item => ["gksudo geany",   'Text Editor As Root',      'geany']},
        {sep => undef},
        {item => ["gnome-disks", 			'Disks',                  				'gnome-disks']},
        {item => ["gksudo gparted", 'GParted',                  'gparted']},
        {item => ["hardinfo", 				'System Profiler and Benchmark',       	'hardinfo']},
        {item => ["xfce4-taskmanager", 		'Taskmanager',                  		'gnome-system-monitor']},

    {end_cat => undef},

    {sep => undef},
    # obmenu-generator
    {begin_cat => ['Obmenu-Generator', 'menu-editor']},
        {item => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-source']},
        {item => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-source']},
        {sep  => undef},
        {item => ['obmenu-generator -p',       'Generate a pipe menu',              'menu-editor']},
        {item => ['obmenu-generator -s -c',    'Generate a static menu',            'menu-editor']},
        {item => ['obmenu-generator -p -i',    'Generate a pipe menu with icons',   'menu-editor']},
        {item => ['obmenu-generator -s -i -c', 'Generate a static menu with icons', 'menu-editor']},
        {sep  => undef},
        {item => ['obmenu-generator -d',       'Refresh Icon Set',                  'gtk-refresh']},
    {end_cat => undef},

    {sep => undef},
    {pipe => ['am-need-to-know-pipemenu',      'Need To Know',                      'stock_about']},
    {sep  => undef},
    {pipe => ['am-help-pipemenu',              'Help &amp; Resources',              'info']},
    {pipe => ['am-kb-pipemenu',                'Display Keybinds',                  'cs-keyboard']},
    ## The xscreensaver lock command
    #{item => ['xscreensaver-command -lock', 'Lock', 'system-lock-screen']},
    {sep => undef},
    {item => ['arcolinux-logout',              'Lock Screen',                       'lock']},
    {item => ['arcolinux-logout',              'Exit Openbox',                      'exit']},

]
