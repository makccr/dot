if [[ ! "$TERM" =~ "screen" ]]; then
tmux attach -t default || tmux new -s default
fi

#neofetch
#transmission-remote -l
#echo ' '
fortune ~/repo/dot/quotes 
#echo ' ' 
#covid
