#!/usr/bin/env python
import requests
import base64
import json
import time
import sys
import mimetypes
from argparse import ArgumentParser
from pathlib import Path

class Spotify:
    def __init__(self, client_cred, cred):
        self.__client_id = json.loads(Path(client_cred).read_text())['client_id']
        self.__client_secret = json.loads(Path(client_cred).read_text())['client_secret']
        self.__cred = cred
        
        if Path(cred).is_file():
            cred_json = json.loads(Path(cred).read_text())
            self.__expire = cred_json['expires_in']
            self.__header = { 'Authorization' : cred_json['token_type'] + ' ' + cred_json['access_token'] }
        else:
            self.register()
    

    def get(self, url, params={}, header={}):
        if time.time() >= self.__expire:
            self.register()

        return requests.get(url, headers=dict(**self.__header, **header), params=params)
    

    def register(self):
        header_basic = { 'Authorization': 'Basic ' + base64.b64encode(f'{self.__client_id}:{self.__client_secret}'.encode('utf-8')).decode() }
        data         = { 'grant_type': 'client_credentials' }
    
        resp = requests.post('https://accounts.spotify.com/api/token', headers=header_basic, data=data)
        if resp.status_code != requests.codes.ok:
            print(f'spotify returned code {resp.status_code}', file=sys.stderr)
            return
        
        self.__expire = int(time.time()) + resp.json()['expires_in']
        self.__header = { 'Authorization' : resp.json()['token_type'] + ' ' + resp.json()['access_token'] }

        save = resp.json()
        save['expires_in'] += int(time.time())
        Path(self.__cred).write_text(json.dumps(save))


def search(token, query):
    search = { 'q': query, 'type': 'album', 'market': 'JP', 'limit': 10, 'offset': 0 }
    
    resp = token.get('https://api.spotify.com/v1/search', params=search, header={'Accept': 'application/json', 'Content-Type': 'application/json'})
    
    if resp.status_code != requests.codes.ok:
        print(f'spotify returned code {resp.status_code}', file=sys.stderr)
        return
    else:
        for item in resp.json()['albums']['items']:
            print(f'url: {item["external_urls"]["spotify"]}')
            print(f'id: {item["id"]}')
            print(f'album name: {item["name"]}')
            artist = ' '.join([a['name'] for a in item['artists']])
            print(f'artist: {artist}')
            print(f'date: {item["release_date"]}')
            print(f'track num: {item["total_tracks"]}')
            print()


def getAlbum(token, id, pic_file):
    full = token.get(f'https://api.spotify.com/v1/albums/{id}')
    
    if full.status_code != requests.codes.ok:
        return
    
    json = full.json()
    
    tracks = [{}] * json['total_tracks']
    
    for track in json['tracks']['items']:
        tracks[track['track_number'] - 1] = {
            'title': track['name'],
            'artist': ', '.join([a['name'] for a in track['artists']])
        }
    
    tag = {
        'album': json['name'],
        'date': json['release_date'],
        'genre': json['genres'][0] if len(json['genres']) > 0 else '',
        'tracks': tracks
    }

    
    if pic_file != '':
        resp = token.get(sorted(json['images'], key=lambda x: x['height'], reverse=True)[0]['url'])

        if resp.status_code != requests.codes.ok:
            return
    
        ext = mimetypes.guess_all_extensions(resp.headers['Content-Type'], strict=False)[0]
        Path(pic_file).with_suffix(ext).write_bytes(resp.content)

    return tag


if __name__ == '__main__':
    token = Spotify('/home/kimotu/.spotify_client', '/home/kimotu/.spotify_cred')

    parser = ArgumentParser()
    subparse = parser.add_subparsers()

    search_parse = subparse.add_parser('search')
    search_parse.add_argument('query')
    search_parse.set_defaults(fn='search')

    get_parse = subparse.add_parser('get')
    get_parse.add_argument('--json')
    get_parse.add_argument('--picture', default='')
    get_parse.add_argument('id')
    get_parse.set_defaults(fn='get')

    args = parser.parse_args()
    if (args.fn == 'search'):
        search(token, args.query)
    else:
        tag = getAlbum(token, args.id, args.picture)

        if args.json:
            Path(args.json).write_text(json.dumps(tag, indent=2, ensure_ascii=False), encoding='utf-8')
        else:
            print(json.dumps(tag, indent=4, ensure_ascii=False))

