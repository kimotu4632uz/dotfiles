#!/bin/sh

nord0='#2E3440'
nord1='#3B4252'
nord2='#434C5E'
nord3='#4C566A'

nord4='#D8DEE9'
nord5='#E5E9F0'
nord6='#ECEFF4'

nord7='#8FBCBB'
nord8='#88C0D0'
nord9='#81A1C1'
nord10='#5E81AC'

nord11='#BF616A'
nord12='#D08770'
nord13='#EBCB8B'
nord14='#A3BE8C'
nord15='#B48EAD'


COLOR_BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff00ffcc'
COLOR_TEXT="$nord1"
COLOR_WRONG="$nord11"
COLOR_VERIFYING="$nord10"
COLOR_RING="$nord1"
COLOR_RING_HI="$nord4"

TIME_SIZE=84
DATE_SIZE=24
TEXT_SIZE=64


sleep 1

i3lock \
--screen 1  \
--clock     \
--indicator \
\
--image ~/Pictures/Wallpapers/Lock/mountain_final.png \
\
--time-str="%k:%M:%S" \
--date-str="%m/%d"    \
--noinput-text=""     \
--no-modkey-text      \
\
--radius 30                \
--ring-width 3             \
--ind-pos="x+w/2:y+h-r-10" \
\
--time-size=$TIME_SIZE                \
--time-pos="ix:y+h/2"                 \
--date-size=$DATE_SIZE                \
--date-pos="ix:ty+$((TIME_SIZE / 2))" \
--verif-size=$TEXT_SIZE               \
--verif-pos="ix:ty"                   \
--wrong-size=$TEXT_SIZE               \
--wrong-pos="ix:ty"                   \
\
--inside-color=$COLOR_BLANK    \
--ring-color=$COLOR_RING       \
--line-color=$COLOR_BLANK      \
--separator-color=$COLOR_BLANK \
\
--insidever-color=$COLOR_BLANK   \
--ringver-color=$COLOR_VERIFYING \
\
--insidewrong-color=$COLOR_BLANK \
--ringwrong-color=$COLOR_WRONG   \
\
--keyhl-color=$COLOR_RING_HI \
--bshl-color=$COLOR_WRONG    \
\
--time-color=$COLOR_TEXT   \
--date-color=$COLOR_TEXT   \
--verif-color=$COLOR_TEXT  \
--wrong-color=$COLOR_WRONG

