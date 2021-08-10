#!/usr/bin/env bash

source ~/.local/share/ptSh/config
test -f ~/.config/ptSh/config && source ~/.config/ptSh/config

if [[ -z $1 ]] || [[ $1 == "--help" ]]; then
    cat <<< "$(mkdir --help)"
    exit
fi

args=""
names=()

read -ra words <<<"$@"

for val in "${words[@]}"; do
    if [[ $val == "-"* ]]; then
        args="$args $val"
    else
        names=(${names[@]} $val)
    fi
done

for name in "${names[@]}"; do
    echo -ne "${DIR_PREFIX_ESCAPE_CODES}${DIR_PREFIX}\x1B[0m"
    echo -e "${DIR_NAME_ESCAPE_CODES}$name\x1B[0m"
    ERR=$(mkdir $args $name 2>&1)
    
    echo -n "└"

    while read -r line; do
        if [[ -z $line ]]; then
            echo -ne "${SUCCESS_PREFIX_ESCAPE_CODES}${SUCCESS_PREFIX}\x1B[0m"
            echo -e "${SUCCESS_MESSAGE_ESCAPE_CODES}${SUCCESS_MESSAGE}\x1B[0m"
        else
            echo -ne "${ERROR_PREFIX_ESCAPE_CODES}${ERROR_PREFIX}\x1B[0m"
            echo -ne "${ERROR_MESSAGE_ESCAPE_CODES}"
            echo -n "$(echo "$line" | sed "s/$1: //g" | sed 's/^[^:]*://g')"
            echo -e "\x1B[0m"
        fi
    done <<< "$ERR"
done
