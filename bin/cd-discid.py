#!/usr/bin/env python
import sys
import getopt
import discid

idonly = False

try:
  opts,args = getopt.getopt(sys.argv[1:], "ih", ["id", "help"])
  for opt,optarg in opts:
    if opt == '-h' or opt == '--help':
      print("usage: cd-discid.py [-h|--help] [-i|--id]")
      exit()
    else:
      idonly = True

except getopt.GetoptError as err:
  print(str(err))
  exit()

if idonly:
  disc = discid.read()
  print(disc.freedb_id.upper())
else:
  disc = discid.read(features=["isrc"])
  print(f'MusicBraiz disc id: {disc.id}')
  print(f'FreeDB disc id:     {disc.freedb_id.upper()}')

  for track in disc.tracks:
    print(f'ISRC of track {track.number}: {track.isrc}')

  print(f'TOC: {disc.toc_string}')

