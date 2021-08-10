#!/usr/bin/env bash

source ~/.local/share/ptSh/config
test -f ~/.config/ptSh/config && source ~/.config/ptSh/config

RESULT=$(cp "$@" 2>&1)

if [[ $1 == "--help" ]]; then
    cat <<< "$RESULT"
    exit
fi

while read -r line; do
    if [[ "$line" == *" -> "* ]]; then
        echo -e "${SUCCESS_PREFIX_ESCAPE_CODES}${SUCCESS_PREFIX}\x1B[0m$line"
    elif [[ -n $line ]];then
        err=$(echo "$line" | sed "s/$1: //g" | sed 's/^[^:]*://g')
        echo -ne "${ERROR_PREFIX_ESCAPE_CODES}${ERROR_PREFIX}\x1B[0m"
        echo -e "${ERROR_MESSAGE_ESCAPE_CODES}$err\x1B[0m"
    else
        echo -ne "${SUCCESS_PREFIX_ESCAPE_CODES}${SUCCESS_PREFIX}\x1B[0m"
        echo -e "${SUCCESS_MESSAGE_ESCAPE_CODES}${SUCCESS_MESSAGE}\x1B[0m"
    fi 
done <<< "$RESULT"
