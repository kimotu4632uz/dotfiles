#!/bin/bash -e

echo "enter metadata"
read -p "album: " album
read -p "artist: " artist
read -p "date: " date
read -p "genre: " genre
read -r -p "picture: " picture
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
cd $tmpdir

/mnt/c/Users/kimot/Programs/cdrtools/win32/cdda2wav.exe -B
id=$(cat audio_01.inf | grep CDDB_DISCID | awk '{print $2}' | sed -E 's/0x(.{8})\r/\U\1/')

if [[ "$picture" == "" ]]; then
    pic_opt=""
else
    pic_opt="--picture "$(wslpath "$picture")
fi

for i in ${!tracks[@]}; do
  iz=$(printf "%02d" $((i + 1)))

  flac -f -8 $pic_opt -T title="${tracks[i]}" -T artist="${artists[i]}" -T album="$album" -T date="$date" -T genre="$genre" -T tracknumber=$((i + 1)) -o ${id}_${iz}.flac audio_${iz}.wav
  opusenc --bitrate 160 $pic_opt --title "${tracks[i]}" --artist "${artists[i]}" --album "$album" --date "$date" --genre "$genre" --tracknumber $((i + 1)) audio_${iz}.wav ${id}_${iz}.opus
done

cd $HOME
mv $tmpdir/*.flac /mnt/c/Users/kimot/Music/Music
mv $tmpdir/*.opus /mnt/c/Users/kimot/Music/Music
rm -rf $tmpdir

