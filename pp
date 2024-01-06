#!/bin/bash
#rensub
#one to one
VALID_EXTENSIONS="avi|mkv|mp4|mpg|m4v|ogv"
[ -z "$1" ] && CWD=. || CWD="$1"
MOVIE=$(find ${CWD} -maxdepth 1 -iname "*.avi" -o -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.mpv" -o -iname "*.m4v" -o -iname "*.ogv" | head -n1)
MFILENAME=$(echo "${MOVIE}" | rev | cut -d "." -f2- | rev)
MEXT=$(echo "${MOVIE}" | rev | cut -d "." -f1 | rev)
mpv "${MOVIE}"