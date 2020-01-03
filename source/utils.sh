type_q() { type "$@" &> /dev/null; }

man2pdf() {
  while read line; do
    gzip -c -d "$line" | mandoc -Tpdf -O paper=a5 > "${line##*/}.pdf"
    #gzip -c -d "$line" | mandoc -Thtml -O style=test.css
  done < <(man -w "$1")
}

