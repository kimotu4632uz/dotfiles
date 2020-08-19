type_q() { type "$@" &> /dev/null; }

man2pdf() {
  while read line; do
    gzip -c -d "$line" | mandoc -Tpdf -O paper=a5 > "${line##*/}.pdf"
    #gzip -c -d "$line" | mandoc -Thtml -O style=test.css
  done < <(man -w "$1")
}

json2bash() {
  jq -r -c 'to_entries | .[] | select(.value | type != "array" and type != "object") | "[\"\(.key)\"]=\"\(.value)\""' "$1" | tr '\n' ' ' | sed -E 's/^(.*)$/( \1 )/g'
}
