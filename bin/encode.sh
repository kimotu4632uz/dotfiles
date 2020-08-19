#!/bin/bash -ue

. $MYENV/source/utils.sh

[[ "$1" == "" ]] && { echo "incorrect arg"; exit 1; }

echo "reading metadata from $1 ..."

declare -A meta=$(json2bash "$1")
readarray -t tracks < <(jq -r '.tracks[].album' "$1")

if [[ "${meta['artist']}" == "" ]]; then
  readarray -t artists < <(jq -r '.tracks[].artist' "$1")
else
  artists=( $(printf "\"$artist\" ""%.s" ${!tracks[@]}) )
fi

tmpdir=$(mktemp -d)
cd $tmpdir

"$USERPROFILE"/Programs/cdrtools/win32/cdda2wav.exe -B
id=$(cat audio_01.inf | grep CDDB_DISCID | awk '{print $2}' | sed -E 's/0x(.{8})\r/\U\1/')

if [[ "${meta['picture']}" == "" ]]; then
    pic_opt=""
else
    pic_opt="--picture "$(wslpath "${meta['picture']}")
fi

for i in ${!tracks[@]}; do
  iz=$(printf "%02d" $((i + 1)))

  flac -f -8 $pic_opt -T title="${tracks[i]}" -T artist="${artists[i]}" -T album="${meta['album']}" -T date="${meta['date']}" -T genre="${meta['genre']}" -T tracknumber=$((i + 1)) -o ${id}_${iz}.flac audio_${iz}.wav
  #opusenc --bitrate 160 $pic_opt --title "${tracks[i]}" --artist "${artists[i]}" --album "$album" --date "$date" --genre "$genre" --tracknumber $((i + 1)) audio_${iz}.wav ${id}_${iz}.opus
done

cd $HOME
mv $tmpdir/*.flac "$USERPROFILE"/Music/
#mv $tmpdir/*.opus "$USERPROFILE"/Music/Music
rm -rf $tmpdir
