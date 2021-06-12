#!/bin/sh

# title: dmenu_websearch <http://efe.kim/dmenu_websearch.html>
# license: CC0
# author: Sunur Efe Vural <efe@efe.kim>
# version: Mar 22, 2019
# dependencies: dmenu, xdotool, hexdump, xprop, setxkbmap, coreutils.

# A  browser-independent address  bar  with bookmark  support. When  the
# cursor is on a web browser it acts as the address bar of that browser.

browser='firefox --new-window'
engine='https://duckduckgo.com/?q=%s'
bookmarks="$HOME/.bookmarks"

gotourl() {
	if [ "$nbrowser" = surf ]
	then
		xprop -id "$winid" -f _SURF_GO 8s -set _SURF_GO "$choice"
	elif [ -n "$winid" ] && [ -z "$nbrowser" ]
	then
		#change layout to us cuz xdotool spasms with non-latin layouts
		layout=$(setxkbmap -query | awk '/^layout:/{ print $2 }')
		setxkbmap -layout us
		xdotool key --clearmodifiers "$shortcut"\
			type --clearmodifiers --delay 2 "$choice"
		xdotool key --clearmodifiers Return
		setxkbmap -layout "$layout"
	elif [ -n "$nbrowser" ]
	then
		$nbrowser "$choice"
	else $browser "$choice"
	fi
}

searchweb() {
	#convert search query to percent encoding and insert it into url
	choice=$(echo "$choice" | hexdump -v -e '/1 " %02x"')
	choice=$(echo "$engine" | sed "s/%s/${choice% 0a}/;s/[[:space:]]/%/g")
	gotourl
}

xprop -root | grep '^_NET_ACTIVE_WINDOW' && {
	winid=$(xprop -root _NET_ACTIVE_WINDOW | sed 's/.*[[:space:]]//')
	class=$(xprop -id "$winid" WM_CLASS | awk -F'\"' '{ print $(NF - 1) }')
	case "$class" in
		Firefox) nbrowser='firefox' ;;
		#Firefox) shortcut='ctrl+l' ;; # alternative method, uses xdotool
		IceCat) nbrowser='icecat' ;;
		Chromium) nbrowser='chromium' ;;
		Chrome) nbrowser='chrome' ;;
		Opera) nbrowser='opera' ;;
		Vivaldi) nbrowser='vivaldi' ;; # not tested
		Brave) nbrowser='brave' ;; # not tested
		Conkeror) nbrowser='conkeror' ;; # not tested
		Palemoon) nbrowser='palemoon' ;; # not tested
		Iceweasel) nbrowser='iceweasel' ;; # not tested
		qutebrowser) nbrowser='qutebrowser' ;;
		Midori) nbrowser='midori' ;; # not that good
		Luakit) nbrowser='luakit' ;; # uses the last window instance
		Uzbl|Vimb) shortcut='o' ;;
		Links) shortcut='g' ;;
		Netsurf*|Epiphany|Dillo|Konqueror|Arora) shortcut='ctrl+l' ;;
		Surf) nbrowser='surf' ; uricur=$(xprop -id "$winid" _SURF_URI |\
				awk -F'\"' '{ print $( NF - 1 ) }') ;;
		*) pid=$(xprop -id "$winid" _NET_WM_PID | awk '{ print $3 }')
			while pgrep -oP "$pid" >/dev/null
			do
				pid=$(pgrep -oP "$pid")
			done
			pname=$(awk '/^Name\:/{ print $NF }' /proc/"$pid"/status) ||
				winid="" ;;
	esac
	[ -n "$pname" ] && case "$pname" in
		w3m) shortcut="U" ;;
		lynx|elinks|links) shortcut="g" ;;
		*) winid="" ;;
	esac
}

tmpfile=$(mktemp /tmp/dmenu_websearch.XXXXXX)
trap 'rm "$tmpfile"' 0 1 15
printf '%s\n%s\n' "$uricur" "$1" > "$tmpfile"
cat "$bookmarks" >> "$tmpfile"
sed -i -E '/^(#|$)/d' "$tmpfile"
choice=$(dmenu -i -p "Go:" -w "$winid" < "$tmpfile") || exit 1

# Detect links without protocol (This is WIP)
protocol='^(https?|ftps?|mailto|about|file):///?'
checkurl() {
	grep -Fx "$choice" "$tmpfile" &&
		choice=$(echo "$choice" | awk '{ print $1 }') && return 0
	[ ${#choice} -lt 4 ] && return 1
	echo "$choice" | grep -Z ' ' && return 1
	echo "$choice" | grep -EiZ "$protocol" && return 0
	echo "$choice" | grep -FZ '..' && return 1
	prepath=$(echo "$choice" | sed 's/(\/|#|\?).*//')
	echo "$prepath" |  grep -FvZ '.' && return 1
	echo "$prepath" |  grep -EZ '^([[:alnum:]~_:-]+\.?){1,3}' && return 0
}

if checkurl
then
	echo "$choice" | grep -EivZ "$protocol" &&
		choice="http://$choice"
	gotourl
else searchweb
fi
