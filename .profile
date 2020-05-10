if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

echo -e '\e[1mTo-do list:\e[0m'
cat ~/Dropbox/writing/notes/To-do.md
echo ' '
fortune ~/repo/dot/.bin/quotes/quotes
echo ' '
covid

# MacPorts tmeportary fix
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

