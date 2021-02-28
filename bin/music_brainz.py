#!/usr/bin/env python

import musicbrainzngs
import mimetypes
import json
import requests
from argparse import ArgumentParser
from pathlib import Path

def get_album(mbid):
    result = musicbrainzngs.get_release_by_id(mbid, includes=['recordings', 'artists'])
    album = result['release']['title']
    date = result['release']['date']
    artist = ''

    for artist_tmp in result['release']['artist-credit']:
        if type(artist_tmp) is dict:
            artist += artist_tmp['artist']['name']
        elif type(artist_tmp) is str:
            artist += artist_tmp

    orig_track_list = result['release']['medium-list'][0]['track-list']

    tracks = []
    for track in sorted(orig_track_list, key=lambda x:x['number']):
        if 'title' in track:
            tracks.append({'title': track['title']})
        else:
            tracks.append({'title': track['recording']['title']})

    return { 'album': album, 'date': date, 'artist': artist, 'tracks': tracks }


def get_picture(mbid):
    imgs = musicbrainzngs.get_image_list(mbid)

    for img in imgs['images']:
        if img['front'] and 'Front' in img['types']:
            return img['image']            


def search_from_jan(jan):
    result = musicbrainzngs.search_releases(barcode=jan)

    if result['release-count'] == 0:
        print('No release found.')
        exit(0)

    return [ release['id'] for release in result['release-list'] ]


def main():
    musicbrainzngs.set_useragent('Sample musicbrainz app', '0.1', 'kimotu4632uz')

    parser = ArgumentParser()
    subparse = parser.add_subparsers()

    search_parse = subparse.add_parser('search')
    search_parse.add_argument('jan')
    search_parse.set_defaults(fn='search')

    get_parse = subparse.add_parser('get')
    get_parse.add_argument('--json')
    get_parse.add_argument('--picture')
    get_parse.add_argument('mbid')
    get_parse.set_defaults(fn='get')

    args = parser.parse_args()
    if (args.fn == 'search'):
        idlist = search_from_jan(args.jan)

        for mbid in idlist:
            tag = get_album(mbid)
            print('MBID: ' + mbid)
            print('url: https://musicbrainz.org/release/' + mbid)
            print('title: ' + tag['album'])
            print('date: ' + tag['date'])
            print('artist: ' + tag['artist'])
            print('tracks: ' + ', '.join([ t['title'] for t in tag['tracks'] ]))
            print()

    else:
        tag = get_album(args.mbid)

        if args.json:
            Path(args.json).write_text(json.dumps(tag, indent=2, ensure_ascii=False), encoding='utf-8')
        else:
            print(json.dumps(tag, indent=4, ensure_ascii=False))
        
        if args.picture:
            url = get_picture(args.mbid)
            resp = requests.get(url)
            resp.raise_for_status()
            Path(args.picture + '.' + url.rsplit('.', 1)[1]).write_bytes(resp.content)


if __name__ == '__main__':
    main()