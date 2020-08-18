#!/bin/bash -eu

let al=0 num=0 length=10
set=""

while getopts 'anl:s:h' OPT; do
  case $OPT in
    a) al=1 ;;
    n) num=1 ;;
    l) let length=$OPTARG ;;
    s) set=$OPTARG ;;
    h) echo "Usage: pass_gen [-a] [-n] [-s string_set] [-l length]"; exit 0 ;;
    *) exit 1 ;;
  esac
done

if [[ "$set" == "" ]]; then
  if ((al && num)); then
    set='[:alnum:]'
  elif (( al )); then
    set='[:alpha:]'
  elif (( num )); then
    set='[:digit:]'
  else
    set='[:graph:]'
  fi
fi

cat /dev/urandom | tr -dc "$set" | fold -w $length | head -1
