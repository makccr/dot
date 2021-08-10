#!/usr/bin/env bash

source ~/.local/share/ptSh/config
test -f ~/.config/ptSh/config && source ~/.config/ptSh/config

columnSize=0
IFS=' '

function getColumnSize(){
    while read -r line; do
        if ((${#line} > columnSize)); then
            columnSize=${#line}
        fi
    done <<<$(ls -Q$arg 2>/dev/null)
}

function setArgs(){
    if [[ $1 != "-"* ]] || [[ $1 == "-l" ]]; then
        arg=""
        return 0
    fi
    if [[ $1 == *"a"* ]]; then
        arg="${arg}a"
    fi
    if [[ $1 == *"A"* ]]; then
        arg="${arg}A"
    fi
}

function align(){
    for (( i=0; i<$((columnSize-(actualChar%columnSize))); i++ )); do
        echo -n " "
    done
}

arg=""
setArgs $1

if [[ ! -z $arg ]];
    then a=$arg
fi

LS="$(ls -Ql$arg --group-directories-first --time-style=+"" 2>/dev/null)"

getColumnSize

columnSize=$((columnSize+LS_MIN_FILE_OFFSET))

if ((${#DIR_PREFIX} > ${#FILE_PREFIX})); then
    columnSize=$((columnSize+${#DIR_PREFIX}))
else
    columnSize=$((columnSize+${#FILE_PREFIX}))
fi

columns=$(($(tput cols) / columnSize))
i=0
actualChar=0
actualColumn=0

while read -r line; do
    read -a words <<< $line
    if [[ $(echo $line | wc -w) == 2 ]]; then continue; fi

    link=false

    if [[ ${words[0]} == "d"* ]]; then
        filename="${DIR_PREFIX_ESCAPE_CODES}${DIR_PREFIX}\x1B[0m${DIR_NAME_ESCAPE_CODES}"
        prefixLength=${#DIR_PREFIX}
    elif [[ ${words[0]} == "l"* ]];then
        filename="${LINK_PREFIX_ESCAPE_CODES}${LINK_PREFIX}\x1B[0m${LINK_NAME_ESCAPE_CODES}"
        prefixLength=${#LINK_PREFIX}
        link=true
    else
        filename="${FILE_PREFIX_ESCAPE_CODES}${FILE_PREFIX}\x1B[0m${FILE_NAME_ESCAPE_CODES}"
        prefixLength=${#FILE_PREFIX}
    fi

    nameLength=$((${#words[5]}-1))
    filename="$filename${words[5]:1}"

    nameWords=0
    if [[ ${words[5]} == "\""* ]]; then
        while [[ ${words[$((5+nameWords))]} != *"\"" ]]; do
            nameWords=$((nameWords+1))
            filename="$filename ${words[$((5+nameWords))]}"
            nameLength=$((nameLength+1+${#words[$((5+nameWords))]}))
        done
    fi
    
    nameLength=$((nameLength-1))
    filename="${filename::-1}"
    filename="$filename\x1B[0m"
    
    actualChar=$((nameLength+prefixLength))
    
    if [[ $1 == *"l"* ]]; then
        echo -ne $filename
        align        
        echo -n "${words[0]} ${words[2]} ${words[3]}"

        if $link; then
            echo " -> ${words[7]:1:-1}"
        else
            echo
        fi
    else
        echo -ne $filename
        align
        actualChar=$((actualChar+(columnSize-(actualChar%columnSize))))
        actualColumn=$((actualColumn+1))
        if (($actualColumn >= $columns)); then
            echo
            actualColumn=0
            actualChar=0
        fi
    fi
done <<<$(echo "$LS")
echo
