#!/bin/bash
#todo:
#creo que VERBOSE_LEVEL está de más en la función si la puede leer desde global, quitar
#curl -s "http://www.omdbapi.com/?apikey=a681a336&t=whatever+works" | jq .
#
####
function die (){
	if [ -z "$2" ]; then
		EXITCODE=250
	else
		EXITCODE=$2
	fi
	echo "$1"
	exit ${EXITCODE}
}
function getFileName (){
	echo "$1" | rev | cut -d "/" -f1 | rev
}
function getDirName (){
	echo "$1" | rev | cut -d "/" -f2 | rev
}
function getFullDir (){
	echo "$1" | rev | cut -d "/" -f2- | rev
}
function before_stop_words() {
	  echo "$1" | tr -c '[:alnum:]' ' ' | tr -s ' '|tr ' ' '\n' | egrep -m 1 -e '[|(|720|1080p|4k|brrip|webrip|dvdrip|hdrip|tvrip|yify|yts.ag|yts.mx|bitloks|pseudo|fullhd|ettv|hdtv|x264|xvid|juggs' -B100 | head -n -1
}


function guess_a(){
  FNAME=$(getFileName "$@"| tr '[:upper:]' '[:lower:]')
	WORDS=$(echo "${FNAME}" | tr -c '[:alnum:]' ' ' | tr -s ' '|tr ' ' '\n' )
	YEAR=$(echo "${WORDS}" | grep -Eo '\b(((19|20)[0-9][0-9])|2100)')
	GUESS_TITLE=$(echo "${WORDS}" | grep -e "${YEAR}" -B100 | head -n-1 | tr '\n' ' ')
#	echo "WORDS:${WORDS}"
#	echo "YEAR:${YEAR}"
	#echo "GUESS_TITLE:${GUESS_TITLE}";	echo "GUESS_YEAR:${YEAR}"
	[ -z "$GUESS_TITLE" ] || echo "${GUESS_TITLE}|${YEAR}"
}
function guess_b(){
  FNAME=$(getDirName "$@"| tr '[:upper:]' '[:lower:]')
	WORDS=$(echo "${FNAME}" | tr -c '[:alnum:]' ' ' | tr -s ' '|tr ' ' '\n' )
	YEAR=$(echo "${WORDS}" | grep -Eo '\b(((19|20)[0-9][0-9])|2100)')
	GUESS_TITLE=$(echo "${WORDS}" | grep -e "${YEAR}" -B100 | head -n-1 | tr '\n' ' ')
#	echo "WORDS:${WORDS}"
#	echo "YEAR:${YEAR}"
	#echo "GUESS_TITLE:${GUESS_TITLE}";	echo "GUESS_YEAR:${YEAR}"
	[ -z "$GUESS_TITLE" ] || echo "${GUESS_TITLE}|${YEAR}"
}
function helper_c(){
  FNAME=$(getDirName "$@"| tr '[:upper:]' '[:lower:]')
	echo $(before_stop_words ${FNAME} | tr '\n' ' ' )
}
function SEARCH(){
	[ -z "$1" ] && return 1
	TITLE=$(echo "$1" | tr ' ' '+')
	[ -z "$2" ] || YEAR="&year=$2"
	#OMDB=$(curl -s "http://www.omdbapi.com/?apikey=a681a336&t=${TITLE}${YEAR}" | jq . )
	OMDB=$(curl -s "http://www.omdbapi.com/?apikey=69133fdb&t=${TITLE}${YEAR}" | jq . )
	echo "${OMDB}"
}
function guess_c(){
  FNAME=$(helper_c $1)
	WORDS=$(echo "${FNAME}" | tr -c '[:alnum:]' ' ' | tr -s ' '|tr ' ' '\n' )
	YEAR=$(echo "${WORDS}" | grep -Eo '\b(((19|20)[0-9][0-9])|2100)')
	GUESS_TITLE=$(echo "${WORDS}" | grep -e "${YEAR}" -B100 | head -n-1 | tr '\n' ' ')
#	echo "WORDS:${WORDS}"
#	echo "YEAR:${YEAR}"
	#echo "GUESS_TITLE:${GUESS_TITLE}";	echo "GUESS_YEAR:${YEAR}"
	[ -z "$GUESS_TITLE" ] || echo "${GUESS_TITLE}|${YEAR}"
}

function getTitleYear(){
		TITLE=$(guess_b ${each}|cut -d "|" -f1)
	 YEAR=$(guess_b ${each}|cut -d "|" -f2)
	[ -z "$TITLE" ] && TITLE=$(guess_a ${each}|cut -d "|" -f1)
	[ -z "$TITLE" ] && TITLE=$(guess_c ${each}|cut -d "|" -f1)
	[ -z "$YEAR" ] && YEAR=""
	echo "${TITLE}|${YEAR}"
}

TITLE=$(getTitleYear "${1}"|cut -d "|" -f1)
YEAR=$(getTitleYear "${1}"|cut -d "|" -f2)
[ -z "$TITLE" ] || [ -z "$YEAR" ] && OMDB=$(SEARCH "${TITLE}") || OMDB=$(SEARCH "${TITLE}" "${YEAR}")
[ -z "$OMDB" ] || echo "${OMDB}"
