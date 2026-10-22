import html
import json
import re
import urllib.request
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'IcelandAtlas/Assets.xcassets'
PHOTOS = [
    ('kirkjufell', 'AsMSF6fkIaA', 'Frugal Flyer', 'photo-1657780576805-ea092344358e'),
    ('skogafoss', 'YQ2v5Sx6ZMk', 'Katarzyna Gonsior', 'photo-1508407728267-5dda0f8e9085'),
    ('lagoon', '_BFAOAzwc-s', 'Cai Photography', 'photo-1720970095848-dfb757f28320'),
    ('beach', 'IT6MIkeDr3o', 'With Paul', 'photo-1680345540388-0f78ec6eaf2a'),
]

def download(photo):
    name, identifier, author, image_id = photo
    page = f'https://unsplash.com/photos/{identifier}'
    if not image_id:
        raise RuntimeError(f'No verified image URL for {name}')
    url = f'https://images.unsplash.com/{image_id}?auto=format&fit=max&w=1800&q=88&fm=jpg'
    folder = ASSETS / f'{name}.imageset'
    folder.mkdir(parents=True, exist_ok=True)
    data = urllib.request.urlopen(url).read()
    (folder / f'{name}.jpg').write_bytes(data)
    (folder / 'Contents.json').write_text(json.dumps({'images':[{'filename':f'{name}.jpg','idiom':'universal'}], 'info':{'author':'xcode','version':1}}, indent=2))
    print(name, len(data))
    return {'asset':name,'photographer':author,'page':page,'image':url,'license':'https://unsplash.com/license'}

if __name__ == '__main__':
    with ThreadPoolExecutor(max_workers=4) as pool:
        results = list(pool.map(download, PHOTOS))
    (ROOT / 'PHOTO_CREDITS.json').write_text(json.dumps(results, ensure_ascii=False, indent=2))
