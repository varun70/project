#!/bin/bash

TRED='\033[1;31m' # Red Text
NC='\033[0m' # No Color

center() {
    local term_width
    term_width=$(tput cols)

    local str="$1"
    local width=${#str}

    # Calculate padding
    local padding=$(( (term_width - width) / 2 ))

    # Print spaces up to the padding amount, then the string
    printf "%-${padding}s" " "
    echo -e "$TRED $str""$NC"
}

frames=(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
        "|                                                      |"
        "|      LINUX    < Linux Is The Future >                |"
        "|                                                      |"
        " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")

for frame in "${frames[@]}"
do
    center "$frame"
    sleep 0.5
done
