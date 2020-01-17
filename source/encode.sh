#!/bin/bash -en

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
  else
    artists+=("$artist")
  fi
done


tmpdir=$(mktemp -d)
pwd="$PWD"
cd $tmpdir
cdparanoia -B

id=$(cd-discid /dev/cdrom | awk '{print $1}')

for i in ${!tracks[@]}; do
  iz=$(printf "%2d" $i)
  [[ ! -e track${iz}.cdda.wav ]] && break

  flac -f -8 --picture $pwd/cover.jpeg -T title="${tracks[i]}" -T artist="${artists[i]}" -T album="$album" -T date="$date" -T genre="$genre" -T tracknumber=$((i + 1)) -o $pwd/${id}_${iz}.flac track${iz}.cdda.wav
  opusenc --bitrate 160 --picture $pwd/cover.jpeg --title "${tracks[i]}" --artist "${artists[i]}" --album "$album" --date "$date" --genre "$genre" --tracknumber $((i + 1)) track${iz}.cdda.wav $pwd/${id}_${iz}.opus
done

rm -rf $tmpdir

