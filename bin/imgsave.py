#!/usr/bin/env python
from bs4 import BeautifulSoup
from datauri import DataURI
import requests

from urllib.parse import urlparse, urljoin
from pathlib import Path
from argparse import ArgumentParser
import mimetypes

def get_urls(url):
    resp = requests.get(url)
    resp.raise_for_status()

    doc = BeautifulSoup(resp.text, 'html.parser')
    urls = set()
    datauris = []

    for img in doc.find_all('img'):
        if img['src'] is not None:
            url = img['src']
            parse_result = urlparse(url)

            if parse_result.scheme == 'http' or parse_result.scheme == 'https':
                urls.add(url)
            elif parse_result.scheme == 'data':
                datauris.append(DataURI(url))
            else:
                urls.append(urljoin(url, parse_result.path))

    return (urls, datauris)


def main():
    parser = ArgumentParser(description='Download images from url by using img tag.')
    parser.add_argument('url', help='url of source html file.')

    args = parser.parse_args()

    (urls, datauris) = get_urls(args.url)
    print(urls)

    if len(urls) > 0:
        print(f'{len(urls)} urls found from image tag.')

    if len(datauris) > 0:
        print(f'{len(datauris)} datauri found from image tag.')
    
    if len(urls) == 0 and len(datauris) == 0:
        print('no file saved.')
        return
    
    for url in urls:
        resp = requests.get(url)
        resp.raise_for_status()
        out = Path(url.rsplit('/', 1)[1])

        if out.exists():
            i = 1
            out_name = out.stem
            while out.exists():
                out = Path(out_name + f'_{i}' + out.suffix)
                i += 1

        out.write_bytes(resp.content)
    
    for (i, datauri) in enumerate(datauris):
        ext = mimetypes.guess_extension(datauri.mimetype, strict=False)
        Path(f'datauri_{i}{ext}').write_bytes(datauri.data)


if __name__ == '__main__':
    main()
