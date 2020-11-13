#!/bin/bash -e

source $MYENV/source/utils.sh

[[ $# == 0 ]] && { echo "Usage: encode.sh [--picture PICTURE] JSON"; exit 0; }
            

for OPT in "$@"; do
    case $OPT in
        -h | --help)
            echo "Usage: encode.sh [--picture PICTURE] JSON"
            exit 0
            ;;

        --picture)
            picture="$2"
            shift 2
            ;;

        -*)
            echo "encode.sh: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;

        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                json="$1"
                shift 1
            fi
            ;;
    esac
done


echo "reading metadata from $json ..."

declare -A meta=$(json2bash "$json")
readarray -t tracks < <(jq -r '.tracks[].title' "$json")

if [[ "${meta['artist']}" == "" ]]; then
  readarray -t artists < <(jq -r '.tracks[].artist' "$json")
else
  declare -a artists=$(printf "\"${meta['artist']}\" ""%.s" ${!tracks[@]} | sed -E 's/^(.*)$/( \1 )/g')
fi

if [[ ${picture-''} == '' ]]; then
    pic_opt=""
else
    pic_opt="--picture $PWD/$picture"
fi

tmpdir=$(mktemp -d)
cd "$tmpdir"

"$USERPROFILE"/Programs/cd-paranoia.exe -B

id=$("$USERPROFILE"/Programs/cdio-discid.exe | tr -dc '[:alnum:]')

if [[ $? != 0 ]]; then
  exit 1
fi

for i in ${!tracks[@]}; do
  iz=$(printf "%02d" $((i + 1)))

  flac -f -8 $pic_opt -T title="${tracks[i]}" -T artist="${artists[i]}" -T album="${meta['album']}" -T date="${meta['date']}" -T genre="${meta['genre']}" -T tracknumber=$((i + 1)) -o ${id}_${iz}.flac track${iz}.cdda.wav
  #opusenc --bitrate 160 $pic_opt --title "${tracks[i]}" --artist "${artists[i]}" --album "$album" --date "$date" --genre "$genre" --tracknumber $((i + 1)) audio_${iz}.wav ${id}_${iz}.opus
done

cd $HOME
mv $tmpdir/*.flac "$USERPROFILE"/Music/
#mv $tmpdir/*.opus "$USERPROFILE"/Music/Music
rm -rf $tmpdir

