#!/bin/bash

flac2tag() {
  for key in "album" "date" "genre"; do
    metaflac --show-tag="$key" "$1" | sed -E 's/([^=]*)=(.*)/\L\1="\2"/'
  done

  printf "tracks=("
  metaflac --show-tag=title "$@" | sed -E 's/.*\:(title|TITLE)=(.*)/"\2"/' | tr '\n' ' '
  printf ")\n"

  artists=$(metaflac --show-tag=artist "$@" | sed -E 's/.*\:(artist|ARTIST)=(.*)/"\2"/')

  if [[ $(echo "$artists" | uniq | wc -l) == 1 ]]; then
    echo "artist=$(head -n 1 <<< $artists)"
  else
    echo "artists=($(tr '\n' ' ' <<< $artists))"
  fi

  if [[ ! -f cover.jpeg ]]; then
    metaflac --export-picture-to=cover.jpeg "$1"
  fi
}

encode() {
  if [[ $# == 1 ]]; then
    source "$1"
  else
    echo "enter metadata"
    read -p "album: " album
    read -p "artist: " artist
    read -p "date: " date
    read -p "genre: " genre
    read -p "number of track: " num

    tracks=(); artists=()

    for i in $(seq $num); do
      read -p "track $i title: " title; tracks+=("$title")

      if [[ "$artist" == "" ]]; then
        read -p "track $i artist: " artist_tmp; artists+=("$artist_tmp")
      fi
    done
  fi

  i=0; while read line; do
    artist=${artists[i]:=$artist}

    flac -f -8 --picture cover.jpeg -T title="${tracks[i]}" -T artist="$artist" -T album="$album" -T date="$date" -T genre="$genre" -T tracknumber=$i "$line"
    opusenc --bitrate 240 --picture cover.jpeg --title "${tracks[i]}" --artist "$artist" --album "$album" --date "$date" --genre "$genre" --tracknumber $i "$line" "${line%.*}.opus"
    #lame -b 320 --ti cover.jpeg --tt "${tracks[i]}" --ta "$artist" --tl "$album" --ty "$date" --tg "$genre" --tn $i --id3v2-only --id3v2-utf16 "$line"
    let i++
  done < <(find . -maxdepth 1 -name "*.wav" | sort)
}

