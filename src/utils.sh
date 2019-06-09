alias CRLF2LF="sed -i -e 's/\r//g' "
alias LF2CRLF="sed -i -e 's/$/\r/' "
alias tab2space="expand -t 4"
alias space2tab="unexpand -t 4"
# git-like and useful diff
alias diff_up="diff -up"
alias diff_dir="diff -uprN"

type_q() { type "$@" &> /dev/null; }

get_pip() { curl -L --ssl https://bootstrap.pypa.io/get-pip.py | sudo -H python; }
add_jp_repo() { sudo sed -i -e "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list; sudo apt update; }
ubuntu_locale_jp() { sudo apt install language-pack-ja; update-locale LANG=ja_JP.UTF-8; }
#enc_files() { find -name "*.wav" -exec sh -c 'echo "{}" | while read line; do flac -8 "$line"; opusenc --vbr --bitrate 240 "$line" "${line%.*}.opus"; done' \; }

# reduce the size of pdf
# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf input.pdf

